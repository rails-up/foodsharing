require_relative '../acceptance_helper'

feature 'Create Donation', %q(
  In order to donate extra food
  I want to be able to create donation
) do

  given(:t_new) { t('donations.index.new') }
  given(:t_title) { t('activerecord.attributes.donation.title') }
  given(:t_description) { t('activerecord.attributes.donation.description') }
  given(:t_city) { t('activerecord.attributes.donation.city') }
  given(:t_special) { t('activerecord.attributes.donation.special') }
  given(:t_submit) { t('donations.form.submit', action: t('common.create')) }
  given(:user) { create(:user) } # FactoryGirl.create
  given(:cafe) { create(:user, role: :cafe) }
  given(:volunteer) { create(:user, role: :volunteer) }
  given(:editor) { create(:user, role: :editor) }
  given(:admin) { create(:user, role: :admin) }

  describe 'Unauthenticated user' do
    scenario 'can not creates donation' do
      visit donations_path
      expect(page).to_not have_link t_new
    end
  end

  describe 'Authentitcated user without role' do
    before do
      sign_in user
      visit donations_path
      create_cities
    end

    scenario 'try create valid donation' do
      click_on t_new
      fill_in t_title, with: 'New donation title'
      fill_in t_description, with: 'New donation description'
      find('#donation_city_id').find(:xpath, '//option[contains(text(), "City 1")]').select_option
      click_on t_submit
      expect(page).to have_content 'New donation title'
      expect(page).to have_content 'New donation description'
      # expect(current_path).to eq donation_path(Donation.all.take)
    end

    scenario 'try create invalid donation' do
      click_on t_new
      fill_in t_title, with: nil
      fill_in t_description, with: nil
      click_on t_submit
      expect(page).to have_content "#{t('activerecord.attributes.donation.title')}
      #{t('activerecord.errors.messages.blank')}"
      expect(page).to have_content "#{t('activerecord.attributes.donation.description')}
      #{t('activerecord.errors.messages.blank')}"
    end

    scenario 'do not create special donation' do
      click_on t_new
      expect(page).to_not have_content t_special
    end
  end

  describe 'Authentitcated user with role :cafe' do
    scenario 'try create special donation' do
      create_cities
      sign_in cafe
      visit donations_path
      click_on t_new
      fill_in t_title, with: 'New donation title'
      fill_in t_description, with: 'New donation description'
      find('#donation_city_id').find(:xpath, '//option[contains(text(), "City 2")]').select_option
      check t_special
      click_on t_submit
      expect(page).to have_content 'New donation title'
      expect(page).to have_content 'New donation description'
      expect(page).to have_content t_special
    end
  end

  describe 'Authentitcated user with role :admin' do
    scenario 'try create special donation' do
      create_cities
      sign_in admin
      visit donations_path
      click_on t_new
      fill_in t_title, with: 'New donation title'
      fill_in t_description, with: 'New donation description'
      find('#donation_city_id').find(:xpath, '//option[contains(text(), "City 4")]').select_option
      check t_special
      click_on t_submit
      expect(page).to have_content 'New donation title'
      expect(page).to have_content 'New donation description'
      expect(page).to have_content t_special
    end
  end

  describe 'Authentitcated user with role :editor' do
    scenario 'do not create special donation' do
      sign_in editor
      visit donations_path
      click_on t_new
      expect(page).to_not have_content t_special
    end
  end

  describe 'Authentitcated user with role :volunteer' do
    scenario 'do not create special donation' do
      sign_in volunteer
      visit donations_path
      click_on t_new
      expect(page).to_not have_content t_special
    end
  end
end
