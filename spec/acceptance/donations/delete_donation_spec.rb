require_relative '../acceptance_helper'

feature 'Delete Donation', %q(
  In order to cancel donation
  I want to be able to delete donation
) do

  given(:donation) { create :donation }

  scenario 'try to delete donation' do
    visit donation_path(donation)
    click_on 'Удалить'
    expect(page).to_not have_content donation.title
  end
end
