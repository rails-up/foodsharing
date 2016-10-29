require_relative '../acceptance_helper'

feature 'Create Article', %q(
  In order to create new article
  User with role :editor should be able to create new article
) do

  given(:t_new) { t('articles.sidebar.new') }
  given(:t_title) { t('activerecord.attributes.article.title') }
  given(:t_content) { t('activerecord.attributes.article.content') }
  given(:t_submit) { t('articles.form.submit', action: t('common.create')) }

  let(:user) { create(:user) }
  before do
    user.editor!
    sign_in user
  end

  before { visit articles_path }

  scenario 'try create valid article' do
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

  scenario 'not logged editor can not create article' do
    sign_out
    expect(page).to_not have_content t_new
  end

end

feature 'User do not create Article', %q(
  In order to not give access to create new article
  User without role :editor should not be able to create new article
) do

  given(:t_new) { t('articles.sidebar.new') }
  given(:t_title) { t('activerecord.attributes.article.title') }
  given(:t_content) { t('activerecord.attributes.article.content') }
  given(:t_submit) { t('articles.form.submit', action: t('common.create')) }

  let(:user) { create(:user) }
  before do
    sign_in user
  end

  before { visit articles_path }

  scenario 'user without role :editor can not create article' do
    expect(page).to_not have_content t_new
  end
end
