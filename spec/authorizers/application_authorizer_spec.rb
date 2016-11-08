require 'rails_helper'

RSpec.describe ApplicationAuthorizer do
  let(:user) { create :user }
  let(:admin) { create :user, role: :admin }

  describe "default strategy" do
    it "lets admin all operations" do
      expect(ApplicationAuthorizer).to be_creatable_by(admin)
      expect(ApplicationAuthorizer).to be_readable_by(admin)
      expect(ApplicationAuthorizer).to be_updatable_by(admin)
      expect(ApplicationAuthorizer).to be_deletable_by(admin)
    end

    it "doesn't let user operations" do
      expect(ApplicationAuthorizer).not_to be_creatable_by(user)
      expect(ApplicationAuthorizer).not_to be_readable_by(user)
      expect(ApplicationAuthorizer).not_to be_updatable_by(user)
      expect(ApplicationAuthorizer).not_to be_deletable_by(user)
    end
  end
end
