require_relative '../acceptance_helper'

feature 'Delete Article', %q(
  In order to remove article
  User with role :editor or :admin should be able to delete article
) do

  given(:t_destroy) { t('common.destroy') }

  given(:user) { create :user }
  given(:editor) { create :user, role: :editor }
  given(:admin) { create :user, role: :admin }
  given(:article) { create :article, user: editor }
  given(:article_another_user) { create :article }

  describe 'Unauthenticated user' do
    scenario 'can not delete article' do
      visit article_path(article)
      expect(page).to_not have_link t_destroy
    end
  end

  describe 'Authentitcated user without role' do
    before { sign_in user }
    scenario 'can not delete article' do
      visit article_path(article)
      expect(page).to_not have_link t_destroy
    end
  end

  describe 'Authentitcated user with role :editor' do
    before { sign_in editor }

    scenario 'can delete own article', js: true do
      visit article_path(article)
      page.accept_confirm do
        click_on t_destroy
      end
      expect(page).to_not have_content article.title
    end

    scenario 'can not delete article another user' do
      visit article_path(article_another_user)
      expect(page).to_not have_link t_destroy
    end
  end

  describe 'Authentitcated user with role :admin' do
    before { sign_in admin }

    scenario 'can delete any article', js: true do
      visit article_path(article)
      page.accept_confirm do
        click_on t_destroy
      end
      expect(page).to_not have_content article.title
    end
  end
end
