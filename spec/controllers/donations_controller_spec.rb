require 'rails_helper'

RSpec.describe DonationsController, type: :controller do
  let(:user) { create :user }
  let(:editor) { create :user, role: :editor }
  let(:cafe) { create :user, role: :cafe }
  let(:volunteer) { create :user, role: :volunteer }
  let(:admin) { create :user, role: :admin }
  let(:another_user) { create :user }
  let(:city) { create :city }

  let(:donation) { create :donation, user: user }
  let(:cafe_donation) { create :donation, user: cafe, special: true }
  let(:volunteer_donation) { create :donation, user: volunteer }
  let(:donation_another_user) { create :donation }

  describe 'GET #index' do
    let(:donations) { create_list(:donation, 2) }
    let(:special_donations) { create_list(:donation, 2, special: true) }

    context 'when user unauthenticated' do
      it 'populates an array of all non special donations' do
        donations
        get :index
        expect(assigns(:donations)).to match_array(donations)
      end

      it 'no populates an array of special donations' do
        special_donations
        get :index
        expect(assigns(:donations)).to_not match_array(special_donations)
      end

      it 'renders index view' do
        donations
        get :index
        expect(response).to render_template :index
      end
    end

    context 'when user have not role' do
      it 'no populates an array of special donations' do
        sign_in user
        special_donations
        get :index
        expect(assigns(:donations)).to_not match_array(special_donations)
      end
    end

    context 'when user has role :editor' do
      it 'no populates an array of special donations' do
        sign_in editor
        special_donations
        get :index
        expect(assigns(:donations)).to_not match_array(special_donations)
      end
    end

    context 'when user has role :cafe' do
      it 'populates an array of special donations' do
        sign_in cafe
        special_donations
        get :index
        expect(assigns(:donations)).to match_array(special_donations)
      end
    end

    context 'when user has role :volunteer' do
      it 'populates an array of special donations' do
        sign_in volunteer
        special_donations
        get :index
        expect(assigns(:donations)).to match_array(special_donations)
      end
    end

    context 'when user has role :admin' do
      it 'populates an array of special donations' do
        sign_in admin
        special_donations
        get :index
        expect(assigns(:donations)).to match_array(special_donations)
      end
    end
  end

  describe 'GET #show' do
    let(:subject) { get :show, params: { id: donation } }
    let(:subject_special) { get :show, params: { id: cafe_donation } }

    context 'when user unauthenticated' do
      it 'assigns the requested donation to @donation' do
        subject
        expect(assigns(:donation)).to eq donation
      end

      it 'renders show view' do
        subject
        expect(response).to render_template :show
      end

      it 'redirect to root if donation is special' do
        subject_special
        expect(response).to redirect_to root_path
      end
    end

    context 'when user have not role' do
      it 'redirect to root if donation is special' do
        sign_in user
        subject_special
        expect(response).to redirect_to root_path
      end
    end

    context 'when user has role :editor' do
      it 'redirect to root if donation is special' do
        sign_in editor
        subject_special
        expect(response).to redirect_to root_path
      end
    end

    context 'when user has role :cafe' do
      it 'renders show view' do
        sign_in cafe
        subject_special
        expect(response).to render_template :show
      end
    end

    context 'when user has role :volunteer' do
      it 'renders show view' do
        sign_in cafe
        subject_special
        expect(response).to render_template :show
      end
    end

    context 'when user has role :admin' do
      it 'renders show view' do
        sign_in cafe
        subject_special
        expect(response).to render_template :show
      end
    end
  end

  describe 'GET #new' do
    context 'when user unauthenticated' do
      before { get :new }

      it 'no assigns a new Donation to @donation' do
        expect(assigns(:donation)).to_not be_a_new(Donation)
      end

      it 'redirect to new user session' do
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when user authenticated and have not role' do
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
  end

  describe 'GET #edit' do
    context 'when user unauthenticated' do
      before { get :edit, params: { id: donation } }

      it 'no assigns the requested donation to @donation' do
        expect(assigns(:donation)).to_not eq donation
      end

      it 'redirect to new user session' do
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when user have not role' do
      before { sign_in user }

      context 'when user is owner donation' do
        it 'assigns the requested donation to @donation' do
          get :edit, params: { id: donation }
          expect(assigns(:donation)).to eq donation
        end

        it 'renders edit view' do
          get :edit, params: { id: donation }
          expect(response).to render_template :edit
        end
      end

      context 'when user is not owner donation' do
        it 'redirect to root' do
          get :edit, params: { id: donation_another_user }
          expect(response).to redirect_to root_path
        end
      end

      context 'when donation is special' do
        it 'redirect to root' do
          get :edit, params: { id: cafe_donation }
          expect(response).to redirect_to root_path
        end
      end
    end

    context 'when user has role :editor' do
      before { sign_in editor }
      context 'when donation is special' do
        it 'redirect to root' do
          get :edit, params: { id: cafe_donation }
          expect(response).to redirect_to root_path
        end
      end
    end

    context 'when user has role :volunteer' do
      before { sign_in volunteer }
      context 'when donation is special' do
        it 'redirect to root' do
          get :edit, params: { id: cafe_donation }
          expect(response).to redirect_to root_path
        end
      end
    end

    context 'when user has role :cafe' do
      before { sign_in cafe }
      context 'when donation is special' do
        it 'renders edit view' do
          get :edit, params: { id: cafe_donation }
          expect(response).to render_template :edit
        end
      end
    end

    context 'when user has role :admin' do
      before { sign_in admin }
      context 'when donation is special' do
        it 'renders edit view' do
          get :edit, params: { id: cafe_donation }
          expect(response).to render_template :edit
        end
      end
    end
  end

  describe 'POST #create' do
    let(:subject) do
      post :create, params: { donation: attributes_for(:donation) }
    end
    let(:special_subject) do
      post :create, params: { donation: attributes_for(:donation).merge(special: true) }
    end
    let(:invalid_subject) do
      post :create, params: { donation: attributes_for(:invalid_donation) }
    end

    context 'when user unauthenticated' do
      it 'does not save the donation' do
        expect { subject }.to_not change(Donation, :count)
      end

      it 'redirect to new user session' do
        subject
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when user have not role' do
      before { sign_in user }

      context 'with valid attributes' do
        it 'saves new donation in the database' do
          expect { subject }.to change(Donation, :count).by(1)
        end

        it 'redirect to show view' do
          subject
          expect(response).to redirect_to donation_path(assigns(:donation))
        end
      end

      context 'with invalid attributes' do
        it 'does not save the donation' do
          expect { invalid_subject }.to_not change(Donation, :count)
        end

        it 're-renders new view' do
          invalid_subject
          expect(response).to render_template :new
        end
      end

      context 'when donation is special' do
        it 'does not save the donation' do
          expect { special_subject }.to_not change(Donation, :count)
        end

        it 'redirect to root' do
          special_subject
          expect(response).to redirect_to root_path
        end
      end

    end

    context 'when user has role :editor' do
      context 'when donation is special' do
        it 'does not save the donation' do
          sign_in editor
          expect { special_subject }.to_not change(Donation, :count)
        end
      end
    end

    context 'when user has role :volunteer' do
      context 'when donation is special' do
        it 'does not save the donation' do
          sign_in volunteer
          expect { special_subject }.to_not change(Donation, :count)
        end
      end
    end

    context 'when user has role :cafe' do
      context 'when donation is special' do
        it 'saves new donation in the database' do
          sign_in cafe
          expect { special_subject }.to change(Donation, :count).by(1)
        end
      end
    end

    context 'when user has role :admin' do
      context 'when donation is special' do
        it 'saves new donation in the database' do
          sign_in admin
          expect { special_subject }.to change(Donation, :count).by(1)
        end
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

    context 'when user without role' do
      context 'try update own donation' do
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

      context 'try edit donation with invalid attributes' do
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

      context 'try update donation another user' do
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

      context 'try set donation as special' do
        before do
          sign_in user
          patch :update,
                params: {
                  id: donation,
                  donation: {
                    title: 'edited title',
                    description: 'edited description',
                    special: true
                  }
                }
        end

        it 'not change donation attributes' do
          donation.reload
          expect(donation.title).to_not eq 'edited title'
          expect(donation.description).to_not eq 'edited description'
          expect(donation.special).to_not eq true
        end

        it 'redirect to root' do
          expect(response).to redirect_to root_path
        end
      end
    end

    context 'when user with role :volunteer' do
      before { sign_in volunteer }

      context 'try set donation as special' do
        before do
          patch :update,
                params: {
                  id: volunteer_donation,
                  donation: {
                    title: 'edited title',
                    description: 'edited description',
                    special: true
                  }
                }
        end

        it 'not change donation attributes' do
          volunteer_donation.reload
          expect(volunteer_donation.title).to_not eq 'edited title'
          expect(volunteer_donation.description).to_not eq 'edited description'
          expect(volunteer_donation.special).to_not eq true
        end

        it 'redirect to root' do
          expect(response).to redirect_to root_path
        end
      end
    end

    context 'when user with role :cafe' do
      before { sign_in cafe }

      context 'try set donation as special' do
        before do
          patch :update,
                params: {
                  id: cafe_donation,
                  donation: {
                    title: 'edited title',
                    description: 'edited description',
                    special: true
                  }
                }
        end

        it 'change donation attributes' do
          cafe_donation.reload
          expect(cafe_donation.title).to eq 'edited title'
          expect(cafe_donation.description).to eq 'edited description'
          expect(cafe_donation.special).to eq true
        end
      end
    end

    context 'when user with role :admin' do
      before { sign_in admin }

      it 'change any donation attributes' do
        patch :update,
              params: {
                id: donation,
                donation: {
                  title: 'edited title',
                  description: 'edited description',
                  special: true
                }
              }

        donation.reload
        expect(donation.title).to eq 'edited title'
        expect(donation.description).to eq 'edited description'
        expect(donation.special).to eq true
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

    context 'when user without role, try delete own donation' do
      before { sign_in user }

      it 'delete donation' do
        expect { destroy_donation }.to change(Donation, :count).by(-1)
      end

      it 'redirect to index view' do
        destroy_donation
        expect(response).to redirect_to donations_path
      end
    end

    context 'when user without role, try delete donation another user' do
      before { sign_in another_user }

      it 'does not delete donation' do
        expect { destroy_donation }.to_not change(Donation, :count)
      end

      it 'redirect to root' do
        destroy_donation
        expect(response).to redirect_to root_path
      end
    end

    context 'when user with role :admin, try delete donation another user' do
      before { sign_in admin }

      it 'delete donation' do
        expect { destroy_donation }.to change(Donation, :count).by(-1)
      end

      it 'redirect to index view' do
        destroy_donation
        expect(response).to redirect_to donations_path
      end
    end
  end
end
