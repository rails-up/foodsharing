require 'rails_helper'

RSpec.describe CompaniesController, type: :controller do
  let(:user) { create :user }
  let(:admin) { create :user, role: :admin }
  let(:another_user) { create :user }

  let(:company) { create :company, user: user }
  let(:company_another_user) { create :company, user: another_user }

  describe 'GET #new' do
    context 'when user is unauthenticated' do
      before { get :new }

      it 'does not assign a new Company to @company' do
        expect(assigns(:company)).to_not be_a_new(Company)
      end

      it 'redirects to a new user session' do
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when user authenticated' do
      before do
        sign_in user
        get :new
      end

      it 'assigns a new Company to @company' do
        expect(assigns(:company)).to be_a_new(Company)
      end

      it 'renders new view' do
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #edit' do
    context 'when user is unauthenticated' do
      before { get :edit, params: { id: company } }

      it 'does not assign the requested company to @company' do
        expect(assigns(:company)).to_not eq company
      end

      it 'redirects to new user session' do
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when user does not have a role' do
      before { sign_in user }

      context 'when user is owner of company' do
        it 'assigns the requested company to @company' do
          get :edit, params: { id: company }
          expect(assigns(:company)).to eq company
        end

        it 'renders edit view' do
          get :edit, params: { id: company }
          expect(response).to render_template :edit
        end
      end

      context 'when user is not owner of company' do
        it 'redirects to root' do
          get :edit, params: { id: company_another_user }
          expect(response).to redirect_to root_path
        end
      end

    end

    context 'when user has role :admin' do
      before { sign_in admin }

      it 'renders edit view' do
        get :edit, params: { id: company_another_user }
        expect(response).to render_template :edit
      end
    end
  end

  describe 'POST #create' do
    let(:subject) do
      post :create, params: { company: attributes_for(:company) }
    end
    let(:invalid_subject) do
      post :create, params: { company: attributes_for(:invalid_company) }
    end

    context 'when user is unauthenticated' do
      it 'does not save the company' do
        expect { subject }.to_not change(Company, :count)
      end

      it 'redirects to new user session' do
        subject
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when user does not have a role' do
      before { sign_in user }

      context 'with valid attributes' do
        it 'saves new company in the database' do
          expect { subject }.to change(Company, :count).by(1)
        end

        it 'redirects to edit user view' do
          subject
          expect(response).to redirect_to edit_user_registration_path
        end
      end

      context 'with invalid attributes' do
        it 'does not save the company' do
          expect { invalid_subject }.to_not change(Company, :count)
        end

        it 're-renders new view' do
          invalid_subject
          expect(response).to render_template :new
        end
      end

    end

    context 'when user has role :admin' do
      context 'when company is special' do
        it 'saves new company in the database' do
          sign_in admin
          expect { subject }.to change(Company, :count).by(1)
        end
      end
    end
  end

  describe 'PATH #update' do
    let(:update_company) do
      patch :update,
            params: {
              id: company,
              company: attributes_for(:company)
            }
    end
    let(:update_company_attr) do
      patch :update,
            params: {
              id: company,
              company: { name: 'edited name', phone: '123456789', address: 'Test Street, 123' }
            }
    end

    context 'when user is unauthenticated' do
      it 'does not change company attributes' do
        update_company_attr
        company.reload
        expect(company.name).to_not eq 'edited name'
        expect(company.phone).to_not eq '123456789'
        expect(company.address).to_not eq 'Test Street, 123'
      end
    end

    context 'when user without role' do
      context 'when updates own company' do
        before { sign_in user }

        it 'assigns the requested company to @company' do
          update_company
          expect(assigns(:company)).to eq company
        end

        it 'changes company attributes' do
          update_company_attr
          company.reload
          expect(company.name).to eq 'edited name'
          expect(company.phone).to eq '123456789'
          expect(company.address).to eq 'Test Street, 123'
        end

        it 'redirects to the updated company' do
          update_company
          expect(response).to redirect_to edit_user_registration_path
        end
      end

      context 'when edit company with invalid attributes' do
        before do
          sign_in user
          patch :update,
                params: {
                  id: company,
                  company: attributes_for(:invalid_company)
                }
        end

        it 'does not change company attributes' do
          company.reload
          expect(company.name).to_not eq nil
          expect(company.phone).to_not eq nil
          expect(company.address).to_not eq nil
        end

        it 'renders edit view' do
          expect(response).to render_template :edit
        end
      end

      context 'try to update company by another user' do
        before do
          sign_in another_user
          update_company_attr
        end

        it 'does not change company attributes' do
          company.reload
          expect(company.name).to_not eq 'edited name'
          expect(company.phone).to_not eq '123456789'
          expect(company.address).to_not eq 'Test Street, 123'
        end

        it 'redirects to the show company' do
          expect(response).to redirect_to root_path
        end
      end

    end

    context 'when user with role :admin' do
      before { sign_in admin }

      it 'changes any company attributes' do
        patch :update,
              params: {
                id: company,
                company: {
                  name: 'edited name',
                  phone: '123456789',
                  address: 'Test Street, 123'
                }
              }

        company.reload
        expect(company.name).to eq 'edited name'
        expect(company.phone).to eq '123456789'
        expect(company.address).to eq 'Test Street, 123'
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:destroy_company) do
      delete :destroy, params: { id: company }
    end
    before { company }

    context 'when user is unauthenticated' do
      it 'does not delete company' do
        expect { destroy_company }.to_not change(Company, :count)
      end
    end

    context 'when user without role, tries to delete own company' do
      before { sign_in user }

      it 'deletes company' do
        expect { destroy_company }.to change(Company, :count).by(-1)
      end

      it 'redirects to edit user view' do
        destroy_company
        expect(response).to redirect_to edit_user_registration_path
      end
    end

    context 'when user without role, tries to delete company belongs to another user' do
      before { sign_in another_user }

      it 'does not delete company' do
        expect { destroy_company }.to_not change(Company, :count)
      end

      it 'redirects to root' do
        destroy_company
        expect(response).to redirect_to root_path
      end
    end

    context 'when user with role :admin, tries to delete company belongs to another user' do
      before { sign_in admin }

      it 'deletes company' do
        expect { destroy_company }.to change(Company, :count).by(-1)
      end

      it 'redirects to index view' do
        destroy_company
        expect(response).to redirect_to edit_user_registration_path
      end
    end
  end
end
