require_relative '../acceptance_helper'

feature 'View Donation', %q(
  Any user can view donation
) do
  given(:user) { create(:user) } # FactoryGirl.create
  given(:cafe) { create(:user, role: :cafe) }
  given(:volunteer) { create(:user, role: :volunteer) }
  given(:editor) { create(:user, role: :editor) }
  given(:admin) { create(:user, role: :admin) }

  given(:donation) { create(:donation) }
  given(:special_donation) { create(:donation, special: true) }

  describe 'Unauthenticated user' do
    scenario 'can view not special donation' do
      visit donation_path(donation)
      expect(page).to have_content donation.title
      expect(page).to have_content donation.description
    end

    scenario 'can not view a special donation' do
      visit donation_path(special_donation)
      expect(page).to_not have_content special_donation.title
      expect(page).to_not have_content special_donation.description
    end
  end

  describe 'Authentitcated user without role' do
    scenario 'can not view a special donation' do
      sign_in user
      visit donation_path(special_donation)
      expect(page).to_not have_content special_donation.title
      expect(page).to_not have_content special_donation.description
    end
  end

  describe 'Authentitcated user with role :editor' do
    scenario 'can not view a special donation' do
      sign_in editor
      visit donation_path(special_donation)
      expect(page).to_not have_content special_donation.title
      expect(page).to_not have_content special_donation.description
    end
  end

  describe 'Authentitcated user with role :cafe' do
    scenario 'can view a special donation' do
      sign_in cafe
      visit donation_path(special_donation)
      expect(page).to have_content special_donation.title
      expect(page).to have_content special_donation.description
    end
  end

  describe 'Authentitcated user with role :volunteer' do
    scenario 'can view a special donation' do
      sign_in volunteer
      visit donation_path(special_donation)
      expect(page).to have_content special_donation.title
      expect(page).to have_content special_donation.description
    end
  end

  describe 'Authentitcated user with role :admin' do
    scenario 'can view a special donation' do
      sign_in admin
      visit donation_path(special_donation)
      expect(page).to have_content special_donation.title
      expect(page).to have_content special_donation.description
    end
  end
end
