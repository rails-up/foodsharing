require_relative '../acceptance_helper'

feature 'View Donation', %q(
  Any user can view donation
) do
  given!(:donation) { create(:donation) }

  scenario 'Any user can view donation' do
    visit donation_path(donation)
    expect(page).to have_content donation.title
    expect(page).to have_content donation.description
  end
end
