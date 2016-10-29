require 'rails_helper'

RSpec.describe Article, type: :model do
  let(:user) { create(:user) }
  before do
    user.editor!
  end

  describe 'validates presence of ...' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :content }
  end

  describe 'has default values' do
    let(:article) { create(:article, user: user) }
    it 'should have status :draft after creation' do
      expect(article.status).to eq 'draft'
    end
  end
end
