require 'rails_helper'

RSpec.describe DonationsController, type: :controller do
  let(:user) { create :user }
  let(:another_user) { create :user }
  let(:donation) { create :donation, user: user }

  describe 'GET #index' do
    let(:donations) { create_list(:donation, 2) }
    before { get :index }

    it 'populates an array of all donations' do
      expect(assigns(:donations)).to match_array(donations)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: donation } }

    it 'assigns the requested donation to @donation' do
      expect(assigns(:donation)).to eq donation
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before do
      sign_in user
      get :new
    end

    it 'assigns a new Donation to @donation' do
      expect(assigns(:donation)).to be_a_new(Donation)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before do
      sign_in user
      get :edit, params: { id: donation }
    end

    it 'assigns the requested donation to @donation' do
      expect(assigns(:donation)).to eq donation
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    let(:subject) do
      post :create, params: { donation: attributes_for(:donation) }
    end
    let(:invalid_subject) do
      post :create, params: { donation: attributes_for(:invalid_donation) }
    end

    context 'when user unauthenticated' do
      it 'does not save the donation' do
        expect { subject }.to_not change(Donation, :count)
      end
    end

    context 'with valid attributes' do
      before { sign_in user }

      it 'saves new donation in the database' do
        expect { subject }.to change(Donation, :count).by(1)
      end

      it 'redirect to show view' do
        subject
        expect(response).to redirect_to donation_path(assigns(:donation))
      end
    end

    context 'with invalid attributes' do
      before { sign_in user }

      it 'does not save the donation' do
        expect { invalid_subject }.to_not change(Donation, :count)
      end

      it 're-renders new view' do
        invalid_subject
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATH #update' do
    let(:update_donation) do
      patch :update,
            params: {
              id: donation,
              donation: attributes_for(:donation)
            }
    end
    let(:update_donation_attr) do
      patch :update,
            params: {
              id: donation,
              donation: { title: 'edited title', description: 'edited description' }
            }
    end

    context 'when user unauthenticated' do
      it 'not change donation attributes' do
        update_donation_attr
        donation.reload
        expect(donation.title).to_not eq 'edited title'
        expect(donation.description).to_not eq 'edited description'
      end
    end

    context 'when user edit own donation' do
      before { sign_in user }

      it 'assigns the requested donation to @donation' do
        update_donation
        expect(assigns(:donation)).to eq donation
      end

      it 'change donation attributes' do
        update_donation_attr
        donation.reload
        expect(donation.title).to eq 'edited title'
        expect(donation.description).to eq 'edited description'
      end

      it 'render to the updated donation' do
        update_donation
        # expect(response).to render_template :update
        expect(response).to redirect_to donation
      end
    end

    context 'when user edit donation another user' do
      before do
        sign_in another_user
        update_donation_attr
      end

      it 'not change donation attributes' do
        donation.reload
        expect(donation.title).to_not eq 'edited title'
        expect(donation.description).to_not eq 'edited description'
      end

      it 'render to the show donation' do
        expect(response).to redirect_to root_path
      end
    end

    context 'then user edit donation with invalid attributes' do
      before do
        sign_in user
        patch :update,
              params: {
                id: donation,
                donation: attributes_for(:invalid_donation)
              }
      end

      it 'not change donation attributes' do
        donation.reload
        expect(donation.title).to_not eq nil
        expect(donation.description).to_not eq nil
      end

      it 'renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:destroy_donation) do
      delete :destroy, params: { id: donation }
    end
    before { donation }

    context 'when user unauthenticated' do
      it 'does not delete donation' do
        expect { destroy_donation }.to_not change(Donation, :count)
      end
    end

    context 'when user authenticated' do
      before { sign_in user }

      it 'delete donation' do
        expect { destroy_donation }.to change(Donation, :count).by(-1)
      end

      it 'redirect to index view' do
        destroy_donation
        expect(response).to redirect_to donations_path
      end
    end

    context 'when user delete donation another user' do
      before { sign_in another_user }

      it 'does not delete donation' do
        expect { destroy_donation }.to_not change(Donation, :count)
      end

      it 'render to the show donation' do
        destroy_donation
        expect(response).to redirect_to root_path
      end
    end
  end
end
