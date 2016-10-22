require_relative '../acceptance_helper'

feature 'Delete Article', %q(
  In order to remove article
  I want to be able to delete article
) do

  given(:t_destroy) { t('common.destroy') }
  given(:article) { create :article }

  scenario 'try to delete article', js: true do
    visit article_path(article)
    page.accept_confirm do
      click_on t_destroy
    end
    expect(page).to_not have_content article.title
  end
end
