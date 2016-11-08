require_relative '../acceptance_helper'

feature 'Edit Article', %q(
  In order to correct article
  User with role :editor or :admin should be able to edit article
) do

  given(:t_edit) { t('common.edit') }
  given(:t_title) { t('activerecord.attributes.article.title') }
  given(:t_content) { t('activerecord.attributes.article.content') }
  given(:t_submit) { t('articles.form.submit', action: t('common.edit')) }
  given(:t_title_error) do
    "#{t('activerecord.attributes.article.title')}
    #{t('activerecord.errors.messages.blank')}"
  end
  given(:t_content_error) do
    "#{t('activerecord.attributes.article.content')}
    #{t('activerecord.errors.messages.blank')}"
  end

  given(:user) { create :user }
  given(:editor) { create :user, role: :editor }
  given(:admin) { create :user, role: :admin }
  given(:article) { create :article, user: editor }
  given(:article_another_user) { create :article }

  describe 'Unauthenticated user' do
    scenario 'can not edit articles' do
      visit article_path(article)
      expect(page).to_not have_link t_edit
    end
  end

  describe 'Authentitcated user without role' do
    before { sign_in user }
    scenario 'can not edit articles' do
      visit article_path(article)
      expect(page).to_not have_link t_edit
    end
  end

  describe 'Authentitcated user with role :editor' do
    before { sign_in editor }

    describe 'can edit own article' do
      before do
        visit article_path(article)
        click_on t_edit
      end

      scenario 'with valid params' do
        fill_in t_title, with: 'Edited article title'
        fill_in t_content, with: 'Edited article content'
        click_on t_submit
        expect(page).to have_content 'Edited article title'
        expect(page).to have_content 'Edited article content'
        expect(page).to_not have_content article.title
        expect(page).to_not have_content article.content
      end

      scenario 'with invalid params' do
        fill_in t_title, with: nil
        fill_in t_content, with: nil
        click_on t_submit
        expect(page).to have_content t_title_error
        expect(page).to have_content t_content_error
      end
    end

    describe 'try edit article another user' do
      scenario 'user not sees link to edit' do
        visit article_path(article_another_user)
        expect(page).to_not have_link t_edit
      end
    end
  end

  describe 'User with role :admin' do
    before { sign_in admin }
    scenario 'can edit article another user' do
      visit article_path(article)
      click_on t_edit
      fill_in t_title, with: 'Edited article title'
      fill_in t_content, with: 'Edited article content'
      click_on t_submit
      expect(page).to have_content 'Edited article title'
      expect(page).to have_content 'Edited article content'
      expect(page).to_not have_content article.title
      expect(page).to_not have_content article.content
    end
  end
end
