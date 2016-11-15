require_relative '../acceptance_helper'

feature 'View Donations list', %q(
  The any user can view a list of donations
) do

  given(:user) { create(:user) } # FactoryGirl.create
  given(:cafe) { create(:user, role: :cafe) }
  given(:volunteer) { create(:user, role: :volunteer) }
  given(:editor) { create(:user, role: :editor) }
  given(:admin) { create(:user, role: :admin) }

  given(:donations) { create_list(:donation, 3) }
  given(:special_donations) { create_list(:donation, 3, special: true) }

  describe 'Unauthenticated user' do
    scenario 'can view a list non special donations' do
      donations
      visit donations_path
      donations.each do |donation|
        expect(page).to have_content donation.title
      end
    end

    scenario 'can not view a list special donations' do
      special_donations
      visit donations_path
      special_donations.each do |donation|
        expect(page).to_not have_content donation.title
      end
    end
  end

  describe 'Authentitcated user without role' do
    scenario 'can not view a list special donations' do
      sign_in user
      special_donations
      visit donations_path
      special_donations.each do |donation|
        expect(page).to_not have_content donation.title
      end
    end
  end

  describe 'Authentitcated user with role :editor' do
    scenario 'can not view a list special donations' do
      sign_in editor
      special_donations
      visit donations_path
      special_donations.each do |donation|
        expect(page).to_not have_content donation.title
      end
    end
  end

  describe 'Authentitcated user with role :cafe' do
    scenario 'can view a list special donations' do
      sign_in cafe
      special_donations
      visit donations_path
      special_donations.each do |donation|
        expect(page).to have_content donation.title
      end
    end
  end

  describe 'Authentitcated user with role :volunteer' do
    scenario 'can view a list special donations' do
      sign_in volunteer
      special_donations
      visit donations_path
      special_donations.each do |donation|
        expect(page).to have_content donation.title
      end
    end
  end

  describe 'Authentitcated user with role :admin' do
    scenario 'can view a list special donations' do
      sign_in admin
      special_donations
      visit donations_path
      special_donations.each do |donation|
        expect(page).to have_content donation.title
      end
    end
  end
end
