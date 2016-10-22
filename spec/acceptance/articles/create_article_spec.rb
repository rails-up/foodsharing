require_relative '../acceptance_helper'

feature 'Create Article', %q(
  In order to create new article
  I want to be able to create new article
) do

  given(:t_new) { t('articles.index.new') }
  given(:t_title) { t('activerecord.attributes.article.title') }
  given(:t_content) { t('activerecord.attributes.article.content') }
  given(:t_submit) { t('articles.form.submit', action: t('common.create')) }

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
end
