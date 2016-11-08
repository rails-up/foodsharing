require 'rails_helper'

RSpec.describe DonationAuthorizer do
  let(:donation) { create :donation }
  let(:user) { create :user }
  let(:admin) { create :user, role: :admin }

  describe "instances" do
    it "lets admin update" do
      expect(donation.authorizer).to be_updatable_by(admin)
    end

    it "lets admin delete" do
      expect(donation.authorizer).to be_deletable_by(admin)
    end

    it "doesn't let user update" do
      expect(donation.authorizer).not_to be_updatable_by(user)
    end

    it "doesn't let user delete" do
      expect(donation.authorizer).not_to be_deletable_by(user)
    end
  end
end
