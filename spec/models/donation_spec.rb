require 'rails_helper'

RSpec.describe Donation, type: :model do
  describe 'associations for ...' do
    it { should belong_to :user }
  end

  describe 'validates presence of ...' do
    # expect(Donation.new(description: 'some description')).to_not be_valid
    it { should validate_presence_of :title }
    it { should validate_presence_of :description }
    it { should validate_presence_of :user_id }
  end
end
