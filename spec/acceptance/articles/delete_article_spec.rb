require_relative '../acceptance_helper'

feature 'Delete Article', %q(
  In order to remove article
  User with role :editor should be able to delete article
) do

  let(:user) { create(:user) }
  before {
    user.editor!
    sign_in user
  }

  given(:t_destroy) { t('common.destroy') }
  given(:article) { create :article, user: user, status: :published }

  scenario 'try to delete article', js: true do
    visit article_path(article)
    page.accept_confirm do
      click_on t_destroy
    end
    expect(page).to_not have_content article.title
  end

  scenario 'not logged user can not delete article' do
    sign_out
    visit article_path(article)
    expect(page).to_not have_content t_destroy
  end
end

feature 'User do not delete Article', %q(
  In order to not give access to remove article
  User without role :editor should not be able to delete article
) do

  let(:user) { create(:user) }
  before do
    user.visitor!
    sign_in user
  end

  given(:t_destroy) { t('common.destroy') }
  given(:article) { create :article, user: user, status: :published }

  scenario 'user without role :editor can not delete article' do
    visit article_path(article)
    expect(page).to_not have_content t_destroy
  end
end

feature 'Delete own Article', %q(
  In order to remove only own article
  User with role :editor should not be able to delete other editors' articles
) do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  before {
    user.editor!
    user2.editor!
    sign_in user2
  }
  given(:t_destroy) { t('common.destroy') }
  given(:article) { create :article, user: user, status: :published }

  scenario 'user with role :editor should not be able to delete other users articles' do
    visit article_path(article)
    expect(page).to_not have_content t_destroy
  end

end
