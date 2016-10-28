require_relative '../acceptance_helper'

feature 'View Articles list', %q(
  Any user can view list of published articles
) do
  given!(:articles) { create_list(:article, 3) }
  scenario 'Any user can not view a list of not published articles' do
    visit articles_path
    articles.each do |article|
      expect(page).to_not have_content article.title
    end
  end

  scenario 'Any user can view a list of published articles' do
    articles.each { |article| article.published! }
    visit articles_path
    articles.each do |article|
      expect(page).to have_content article.title
    end
  end
end
