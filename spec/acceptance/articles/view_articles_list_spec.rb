require_relative '../acceptance_helper'

feature 'View Articles list', %q(
  Any user can view list of published articles
) do

  given(:user) { create :user }
  given(:editor) { create :user, role: :editor }
  given(:admin) { create :user, role: :admin }
  given(:published_articles) { create_list(:article, 3, user: editor, status: :published) }
  given(:articles) { create_list(:article, 3, user: editor, status: :draft) }
  given(:articles_another_user) { create_list(:article, 3, status: :draft) }

  describe 'Unauthenticated user' do
    scenario 'can not view draft articles' do
      articles
      visit articles_path(my_articles: :draft)
      articles.each do |article|
        expect(page).to_not have_content article.title
      end
    end

    scenario 'can view published articles' do
      published_articles
      visit articles_path
      published_articles.each do |article|
        expect(page).to have_content article.title
      end
    end
  end

  describe 'Authenticated user without role' do
    before { sign_in user }

    scenario 'can not view draft articles' do
      articles
      visit articles_path(my_articles: :draft)
      articles.each do |article|
        expect(page).to_not have_content article.title
      end
    end

    scenario 'can view published articles' do
      published_articles
      visit articles_path
      published_articles.each do |article|
        expect(page).to have_content article.title
      end
    end
  end

  describe 'Authenticated user with role :editor' do
    before { sign_in editor }

    scenario 'author can view draft articles' do
      articles
      visit articles_path(my_articles: :draft)
      articles.each do |article|
        expect(page).to have_content article.title
      end
    end

    scenario 'can not view draft another user' do
      articles_another_user
      visit articles_path(my_articles: :draft)
      articles_another_user.each do |article|
        expect(page).to_not have_content article.title
      end
    end
  end

  describe 'Authenticated user with role :admin' do
    # before { sign_in admin }

    # scenario 'can view draft articles another user' do
    #   articles
    #   visit articles_path(my_articles: :draft)
    #   articles.each do |article|
    #     expect(page).to have_content article.title
    #   end
    # end
  end
end
