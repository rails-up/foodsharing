require_relative '../acceptance_helper'

feature 'Create Donation', %q(
  In order to donate extra food
  I want to be able to create donation
) do

  before { visit donations_path }

  scenario 'try create valid donation' do
    click_on 'Добавить предложение'
    fill_in 'Заголовок', with: 'New donation title'
    fill_in 'Описание', with: 'New donation description'
    click_on 'Сохранить'
    expect(page).to have_content 'New donation title'
    expect(page).to have_content 'New donation description'
    # expect(current_path).to eq donation_path(Donation.all.take)
  end

  scenario 'try create invalid donation' do
    click_on 'Добавить предложение'
    fill_in 'Заголовок', with: nil
    fill_in 'Описание', with: nil
    click_on 'Сохранить'
    expect(page).to have_content "Title can't be blank"
    expect(page).to have_content "Description can't be blank"
  end
end
