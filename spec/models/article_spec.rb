require 'rails_helper'

RSpec.describe Article, type: :model do
  describe 'validates presence of ...' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :content }
  end
end
