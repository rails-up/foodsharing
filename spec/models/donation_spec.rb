require 'rails_helper'

RSpec.describe Donation, type: :model do
  describe 'validates presence of ...' do
    # expect(Donation.new(description: 'some description')).to_not be_valid
    it { should validate_presence_of :title }
    it { should validate_presence_of :description }
  end
end
