require 'rails_helper'

RSpec.describe Company, type: :model do
  let(:user) { create(:user) }
  let(:company) { create(:company, user: user) }
  let(:invalid_company) { build(:invalid_company) }

  describe 'associations for ...' do
    it { should belong_to(:user) }
  end

  describe 'validates presence of ...' do
    it { should validate_uniqueness_of :name }
    it { should validate_presence_of :name }
    it { should validate_presence_of :phone }
    it { should validate_presence_of :address }
  end

  it "is valid with all attributes" do
    expect(company).to be_valid
  end
  it "is invalid without required attributes" do
    expect(invalid_company).not_to be_valid
  end
end
