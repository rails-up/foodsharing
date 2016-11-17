require 'rails_helper'

RSpec.describe DonationAuthorizer do
  let(:user) { create :user }
  let(:volunteer) { create :user, role: :volunteer }
  let(:cafe) { create :user, role: :cafe }
  let(:admin) { create :user, role: :admin }

  let(:donation) { create :donation, user: user }
  let(:volunteer_donation) { create :donation, user: volunteer }
  let(:special_donation) { create :donation, user: cafe, special: true }

  describe 'class' do
    context 'specializable_by?' do
      context 'when user have not role' do
        it 'does not let user specialize for action :index' do
          expect(DonationAuthorizer).to_not be_specializable_by(user, :index)
        end

        it 'does not let user specialize for action :new' do
          expect(DonationAuthorizer).to_not be_specializable_by(user, :new)
        end

        it 'does not let user specialize for action :create' do
          expect(DonationAuthorizer).to_not be_specializable_by(user, :create)
        end

        it 'does not let user specialize for action :edit' do
          expect(DonationAuthorizer).to_not be_specializable_by(user, :edit)
        end

        it 'does not let user specialize for action :update' do
          expect(DonationAuthorizer).to_not be_specializable_by(user, :update)
        end
      end

      context 'when user have role :volunteer' do
        it 'lets volunteer specialize for action :index' do
          expect(DonationAuthorizer).to be_specializable_by(volunteer, :index)
        end

        it 'does not let volunteer specialize for action :new' do
          expect(DonationAuthorizer).to_not be_specializable_by(volunteer, :new)
        end

        it 'does not let volunteer specialize for action :create' do
          expect(DonationAuthorizer).to_not be_specializable_by(volunteer, :create)
        end

        it 'does not let volunteer specialize for action :edit' do
          expect(DonationAuthorizer).to_not be_specializable_by(volunteer, :edit)
        end

        it 'does not let volunteer specialize for action :update' do
          expect(DonationAuthorizer).to_not be_specializable_by(volunteer, :update)
        end
      end

      context 'when user have role :cafe' do
        it 'lets cafe specialize for action :index' do
          expect(DonationAuthorizer).to be_specializable_by(cafe, :index)
        end

        it 'lets cafe specialize for action :new' do
          expect(DonationAuthorizer).to be_specializable_by(cafe, :new)
        end

        it 'lets cafe specialize for action :create' do
          expect(DonationAuthorizer).to be_specializable_by(cafe, :create)
        end

        it 'lets cafe specialize for action :edit' do
          expect(DonationAuthorizer).to be_specializable_by(cafe, :edit)
        end

        it 'lets cafe specialize for action :update' do
          expect(DonationAuthorizer).to be_specializable_by(cafe, :update)
        end
      end

      context 'when user have role :admin' do
        it 'lets admin specialize for action :index' do
          expect(DonationAuthorizer).to be_specializable_by(admin, :index)
        end

        it 'lets admin specialize for action :new' do
          expect(DonationAuthorizer).to be_specializable_by(admin, :new)
        end

        it 'lets admin specialize for action :create' do
          expect(DonationAuthorizer).to be_specializable_by(admin, :create)
        end

        it 'lets admin specialize for action :edit' do
          expect(DonationAuthorizer).to be_specializable_by(admin, :edit)
        end

        it 'lets admin specialize for action :update' do
          expect(DonationAuthorizer).to be_specializable_by(admin, :update)
        end
      end
    end
  end

  describe 'instances' do
    context 'creatable_by?' do
      context 'when user have not role' do
        it 'lets user create donation' do
          expect(donation.authorizer).to be_creatable_by(user)
        end

        it 'does not let user create special donation' do
          expect(special_donation.authorizer).to_not be_creatable_by(user)
        end
      end

      context 'when user have role :volunteer' do
        it 'lets volunteer create donation' do
          expect(donation.authorizer).to be_creatable_by(volunteer)
        end

        it 'does not let volunteer create special donation' do
          expect(special_donation.authorizer).to_not be_creatable_by(volunteer)
        end
      end

      context 'when user have role :cafe' do
        it 'lets cafe create donation' do
          expect(donation.authorizer).to be_creatable_by(cafe)
        end

        it 'lets cafe create special donation' do
          expect(special_donation.authorizer).to be_creatable_by(cafe)
        end
      end

      context 'when user have role :admin' do
        it 'lets admin create donation' do
          expect(donation.authorizer).to be_creatable_by(admin)
        end

        it 'lets admin create special donation' do
          expect(special_donation.authorizer).to be_creatable_by(admin)
        end
      end
    end

    context 'readable_by?' do
      context 'when user have not role' do
        it 'lets user read donation' do
          expect(donation.authorizer).to be_readable_by(user)
        end

        it 'does not let user read special donation' do
          expect(special_donation.authorizer).to_not be_readable_by(user)
        end
      end

      context 'when user have role :volunteer' do
        it 'lets volunteer read donation' do
          expect(donation.authorizer).to be_readable_by(volunteer)
        end

        it 'lets volunteer read special donation' do
          expect(special_donation.authorizer).to be_readable_by(volunteer)
        end
      end

      context 'when user have role :cafe' do
        it 'lets cafe read donation' do
          expect(donation.authorizer).to be_readable_by(cafe)
        end

        it 'lets cafe read special donation' do
          expect(special_donation.authorizer).to be_readable_by(cafe)
        end
      end

      context 'when user have role :admin' do
        it 'lets admin read donation' do
          expect(donation.authorizer).to be_readable_by(admin)
        end

        it 'lets admin read special donation' do
          expect(special_donation.authorizer).to be_readable_by(admin)
        end
      end
    end

    context 'updatable_by?' do
      context 'when user have not role' do
        it 'lets user update donation' do
          expect(donation.authorizer).to be_updatable_by(user)
        end

        it 'does not let user update special donation' do
          expect(special_donation.authorizer).to_not be_updatable_by(user)
        end
      end

      context 'when user have role :volunteer' do
        it 'lets volunteer update donation' do
          expect(volunteer_donation.authorizer).to be_updatable_by(volunteer)
        end

        it 'does not let volunteer update special donation' do
          expect(special_donation.authorizer).to_not be_updatable_by(volunteer)
        end
      end

      context 'when user have role :cafe' do
        it 'lets cafe update special donation' do
          expect(special_donation.authorizer).to be_updatable_by(cafe)
        end
      end

      context 'when user have role :admin' do
        it 'lets admin update donation' do
          expect(donation.authorizer).to be_updatable_by(admin)
        end

        it 'lets admin update special donation' do
          expect(special_donation.authorizer).to be_updatable_by(admin)
        end
      end
    end

    context 'deletable_by?' do
      context 'when user have not role' do
        it 'lets user delete donation' do
          expect(donation.authorizer).to be_deletable_by(user)
        end

        it 'does not let user delete not his donation' do
          expect(special_donation.authorizer).to_not be_deletable_by(volunteer)
        end
      end

      context 'when user have role :volunteer' do
        it 'lets volunteer delete donation' do
          expect(volunteer_donation.authorizer).to be_deletable_by(volunteer)
        end
      end

      context 'when user have role :cafe' do
        it 'lets cafe delete special donation' do
          expect(special_donation.authorizer).to be_deletable_by(cafe)
        end
      end

      context 'when user have role :admin' do
        it 'lets admin delete special donation' do
          expect(special_donation.authorizer).to be_deletable_by(admin)
        end
      end
    end
  end
end
