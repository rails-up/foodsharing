require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations for ...' do
    it { should have_many(:donations).dependent(:destroy) }
    it { should have_one(:company).dependent(:destroy) }
    it { should have_many(:authorizations).dependent(:destroy) }
  end

  describe 'validates presence of ...' do
    it { should validate_presence_of :full_name }
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end

  describe '.find_for_oauth' do
    let!(:user) { create :user }
    let(:auth) do
      OmniAuth::AuthHash.new(provider: 'vkontakte',
                             uid: 'abcd',
                             info: { email: user.email })
    end

    context 'user already has authorization' do
      it 'return the user' do
        user.authorizations.create(provider: 'vkontakte', uid: 'abcd')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has not authorization' do
      context 'user already exists' do
        it 'does not create new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns the user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user does not exist' do
        let(:auth) do
          OmniAuth::AuthHash.new(provider: 'vkontakte',
                                 uid: 'abcd',
                                 info: {
                                   email: 'mail@mail.com',
                                   name: 'Name'
                                 })
        end

        it 'creates new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end

        it 'returns new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'fills user full name' do
          user = User.find_for_oauth(auth)
          expect(user.full_name).to eq auth.info[:name]
        end

        it 'fills user email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info[:email]
        end

        it 'creates authorization for user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first
          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end
end
