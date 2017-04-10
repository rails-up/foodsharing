require 'rails_helper'

RSpec.describe Place, type: :model do
  let(:city) { create(:city) }
  let(:place) { create(:place, city: city) }
  let(:invalid_place) { build(:invalid_place) }

  describe 'associations for ...' do
    it { should belong_to(:city) }
  end

  describe 'validates presence of ...' do
    it { should validate_presence_of :city }
  end

  it "is valid with all attributes" do
    expect(place).to be_valid
  end
  it "is invalid without required attributes" do
    expect(invalid_place).not_to be_valid
  end

end
