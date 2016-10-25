require_relative '../acceptance_helper'

feature 'Delete Article', %q(
  In order to remove article
  I want to be able to delete article
) do

  let(:user) { create(:user) }
  before { sign_in user }

  given(:t_destroy) { t('common.destroy') }
  given(:article) { create :article }

  scenario 'try to delete article', js: true do
    visit article_path(article)
    page.accept_confirm do
      click_on t_destroy
    end
    expect(page).to_not have_content article.title
  end

  scenario 'not logged user can not delete article' do
    sign_out user
    visit article_path(article)
    expect(page).to_not have_content t_destroy
  end
end
