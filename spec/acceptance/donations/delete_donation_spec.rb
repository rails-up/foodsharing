require_relative '../acceptance_helper'

feature 'Delete Donation', %q(
  In order to cancel donation
  I want to be able to delete donation
) do

  given(:t_destroy) { t('common.destroy') }
  given(:donation) { create :donation }

  scenario 'try to delete donation' do
    visit donation_path(donation)
    click_on t_destroy
    expect(page).to_not have_content donation.title
  end
end
