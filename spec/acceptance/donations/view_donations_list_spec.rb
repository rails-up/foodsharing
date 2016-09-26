require_relative '../acceptance_helper'

feature 'View Donations list', %q(
  The user can view a list of donations
) do
  given!(:donations) { create_list(:donation, 3) }

  scenario 'Any user can view a list of donations' do
    visit donations_path
    donations.each do |donation|
      expect(page).to have_content donation.title
    end
  end
end
