require_relative '../acceptance_helper'

feature 'Edit Article', %q(
  In order to correct article
  User with role :editor should be able to edit article
) do

  let(:user) { create(:user) }
  before do
    user.editor!
    sign_in user
  end

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
  given(:article) { create :article, user: user }

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
    sign_out
    visit article_path(article)
    expect(page).to_not have_content t_edit
  end
end

feature 'User do not edit Article', %q(
  In order to prohibit editing article
  User without role :editor should not be able to edit article
) do

  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  before do
    user.editor!
    user2.editor!
    sign_in user
  end
  given(:article) { create :article, user: user }
  given(:article2) { create :article, user: user2 }

  given(:t_edit) { t('common.edit') }

  scenario 'user without role :editor can not edit article' do
    user.visitor!
    visit article_path(article)
    expect(page).to_not have_content t_edit
  end

  scenario 'user with role :editor can edit only own articles' do
    visit article_path(article2)
    expect(page).to_not have_content t_edit
  end
end
