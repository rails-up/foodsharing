require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validates presence of ...' do
    it { should validate_presence_of :full_name }
  end
end
