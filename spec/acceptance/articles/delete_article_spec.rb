require_relative '../acceptance_helper'

feature 'Delete Article', %q(
  In order to remove article
  I want to be able to delete article
) do

  given(:t_destroy) { t('common.destroy') }
  given(:article) { create :article }

  scenario 'try to delete article' do
    visit article_path(article)
    click_on t_destroy
    # after confirmation it should redirect to articles_path where we can see title:
    expect(page).to have_content t('articles.index.title')
  end
end
