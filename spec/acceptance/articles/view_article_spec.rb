require_relative '../acceptance_helper'

feature 'View Article', %q(
  Any user can view published articles
  User with role :editor or :admin should be able view draft article
) do

  given(:user) { create :user }
  given(:editor) { create :user, role: :editor }
  given(:admin) { create :user, role: :admin }
  given!(:article) { create :article, user: editor, status: :draft }
  given!(:published_article) { create :article, user: editor, status: :published }
  given(:article_another_user) { create :article, status: :draft}

  describe 'Unauthenticated user' do
    scenario 'can not view draft articles' do
      visit article_path(article)
      expect(page).to_not have_content article.title
      expect(page).to_not have_content article.content
    end

    scenario 'can view published articles' do
      visit article_path(published_article)
      expect(page).to have_content published_article.title
      expect(page).to have_content published_article.content
    end
  end

  describe 'Authenticated user without role' do
    before { sign_in user }

    scenario 'can not view draft articles' do
      visit article_path(article)
      expect(page).to_not have_content article.title
      expect(page).to_not have_content article.content
    end

    scenario 'can view published articles' do
      visit article_path(published_article)
      expect(page).to have_content published_article.title
      expect(page).to have_content published_article.content
    end
  end

  describe 'Authenticated user with role :editor' do
    before { sign_in editor }

    scenario 'author article can see draft' do
      visit article_path(article)
      expect(page).to have_content article.title
      expect(page).to have_content article.content
    end

    scenario 'not author article can not see draft' do
      visit article_path(article_another_user)
      expect(page).to_not have_content article_another_user.title
      expect(page).to_not have_content article_another_user.content
    end
  end

  describe 'Authenticated user with role :admin' do
    before { sign_in admin }

    scenario 'can see draft another user' do
      visit article_path(article_another_user)
      expect(page).to have_content article_another_user.title
      expect(page).to have_content article_another_user.content
    end
  end
end
