require_relative '../acceptance_helper'

feature 'Edit Article', %q(
  In order to correct article
  I wan to be able to edit article
) do

  let(:user) { create(:user) }
  before { sign_in user }

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
  given(:article) { create :article }

  scenario 'try to edit article with valid params' do
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

  scenario 'try to edit article with invalid params' do
    visit article_path(article)
    click_on t_edit
    fill_in t_title, with: nil
    fill_in t_content, with: nil
    click_on t_submit
    expect(page).to have_content t_title_error
    expect(page).to have_content t_content_error
  end

  scenario 'not logged user can not edit article' do
    sign_out user
    visit article_path(article)
    expect(page).to_not have_content t_edit
  end
end
