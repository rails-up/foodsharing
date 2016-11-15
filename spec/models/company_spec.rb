require 'rails_helper'

RSpec.describe Company, type: :model do
  describe 'associations for ...' do
    it { should have_many(:users) }
  end

  describe 'validates presence of ...' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :phone }
    it { should validate_presence_of :address }
  end
end
