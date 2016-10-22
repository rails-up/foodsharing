require_relative '../acceptance_helper'

feature 'View Articles list', %q(
  Any user can view list of articles
) do
  given!(:articles) { create_list(:article, 3) }

  scenario 'Any user can view a list of articles' do
    visit articles_path
    articles.each do |article|
      expect(page).to have_content article.title
    end
  end
end
