require_relative '../acceptance_helper'

feature 'Create Article', %q(
  In order to create new article
  User with role :editor or :admin should be able to create new article
) do

  given(:t_new) { t('articles.sidebar.new') }
  given(:t_title) { t('activerecord.attributes.article.title') }
  given(:t_content) { t('activerecord.attributes.article.content') }
  given(:t_submit) { t('articles.form.submit', action: t('common.create')) }

  given(:user) { create :user }
  given(:editor) { create :user, role: :editor }
  given(:admin) { create :user, role: :admin }

  describe 'Unauthenticated user' do
    scenario 'can not creates articles' do
      visit articles_path
      expect(page).to_not have_link t_new
    end
  end

  describe 'Authentitcated user without role' do
    before { sign_in user }
    scenario 'can not creates articles' do
      visit articles_path
      expect(page).to_not have_link t_new
    end
  end

  describe 'Authentitcated user with role :editor' do
    before do
      sign_in editor
      visit articles_path
    end

    scenario 'can create valid article' do
      click_on t_new
      fill_in t_title, with: 'New article title'
      fill_in t_content, with: 'New article content'
      click_on t_submit
      expect(page).to have_content 'New article title'
      expect(page).to have_content 'New article content'
    end

    scenario 'try create invalid article' do
      click_on t_new
      fill_in t_title, with: nil
      fill_in t_content, with: nil
      click_on t_submit
      expect(page).to have_content "#{t('activerecord.attributes.article.title')}
      #{t('activerecord.errors.messages.blank')}"
      expect(page).to have_content "#{t('activerecord.attributes.article.content')}
      #{t('activerecord.errors.messages.blank')}"
    end
  end

  describe 'Authentitcated user with role :admin' do
    before do
      sign_in admin
      visit articles_path
    end

    scenario 'can create article' do
      click_on t_new
      fill_in t_title, with: 'New article title'
      fill_in t_content, with: 'New article content'
      click_on t_submit
      expect(page).to have_content 'New article title'
      expect(page).to have_content 'New article content'
    end
  end
end
