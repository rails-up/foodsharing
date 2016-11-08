require_relative '../acceptance_helper'

feature 'Delete Donation', %q(
  In order to cancel donation
  I want to be able to delete donation
) do

  given(:t_destroy) { t('common.destroy') }
  given(:user) { create :user }
  given(:admin) { create :user, role: :admin }
  given(:donation) { create :donation, user: user }
  given(:donation_another_user) { create :donation }

  describe 'Unauthenticated user' do
    scenario 'can not delete donation' do
      visit donation_path(donation)
      expect(page).to_not have_link t_destroy
    end
  end

  describe 'Authenticated user without role' do
    before { sign_in user }
    scenario 'try to delete own donation' do
      visit donation_path(donation)
      click_on t_destroy
      expect(page).to_not have_content donation.title
    end
    scenario 'can not delete donation another user' do
      visit donation_path(donation_another_user)
      expect(page).to_not have_link t_destroy
    end
  end

  describe 'User with role :admin' do
    before { sign_in admin }
    scenario 'can delete donation another user' do
      visit donation_path(donation)
      click_on t_destroy
      expect(page).to_not have_content donation.title
    end
  end
end
