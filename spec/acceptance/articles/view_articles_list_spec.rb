require_relative '../acceptance_helper'

feature 'View Articles list', %q(
  Any user can view list of published articles
) do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  before do
    user.editor!
    user2.editor!
    sign_in user
  end
  given!(:articles) { create_list(:article, 3, user: user) }
  given(:article) { create :article, user: user2, status: :published }

  scenario 'Any user can not view a list of not published articles' do
    visit articles_path
    articles.each do |article|
      expect(page).to_not have_content article.title
    end
  end

  scenario 'Any user can view a list of published articles' do
    articles.each { |article| article.published! }
    visit articles_path
    articles.each do |article|
      expect(page).to have_content article.title
    end
  end

  scenario 'User can not see not published article if he is not author' do
    visit article_path(article)
    expect(page).to have_content article.title    
  end
end
