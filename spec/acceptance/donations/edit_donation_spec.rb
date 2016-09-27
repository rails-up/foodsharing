require_relative '../acceptance_helper'

feature 'Edit Donation', %q(
  In order to fix donation
  I want to be able to edit donation
) do

  given(:donation) { create :donation }

  scenario 'try to edit donation with valid params' do
    visit donation_path(donation)
    click_on 'Изменить'
    fill_in 'Заголовок', with: 'Edited donation title'
    fill_in 'Описание', with: 'Edited donation description'
    click_on 'Сохранить'
    expect(page).to have_content 'Edited donation title'
    expect(page).to have_content 'Edited donation description'
    expect(page).to_not have_content donation.title
    expect(page).to_not have_content donation.description
  end

  scenario 'try to edit donation with invalid params' do
    visit donation_path(donation)
    click_on 'Изменить'
    fill_in 'Заголовок', with: nil
    fill_in 'Описание', with: nil
    click_on 'Сохранить'
    expect(page).to have_content "Title can't be blank"
    expect(page).to have_content "Description can't be blank"
  end
end
