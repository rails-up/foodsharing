require_relative '../acceptance_helper'

feature 'View Articles list', %q(
  Any user can view list of published articles
) do

  let(:user) { create(:user) }
  given(:articles) { create_list(:article, 3) }
  given(:published_articles) { create_list(:article, 3, status: :published) }
  given(:article) { create :article, user: user }
  given(:article_another_user) { create :article }

  describe 'Unauthenticated user' do
    scenario 'can not view draft articles' do
      articles
      visit articles_path
      articles.each do |article|
        expect(page).to_not have_content article.title
      end
    end

    scenario 'can view published articles' do
      published_articles
      visit articles_path
      published_articles.each do |article|
        expect(page).to have_content article.title
      end
    end
  end

  describe 'Authenticated user without role' do
    before { sign_in user }

    scenario 'author article can see draft' do
      visit article_path(article)
      expect(page).to have_content article.title
    end

    scenario 'not author article can not see draft' do
      visit article_path(article_another_user)
      expect(page).to_not have_content article_another_user.title
    end
  end
end
