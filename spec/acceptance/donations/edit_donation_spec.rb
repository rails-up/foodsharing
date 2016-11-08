require_relative '../acceptance_helper'

feature 'Edit Donation', %q(
  In order to fix donation
  I want to be able to edit donation
) do

  given(:t_edit) { t('common.edit') }
  given(:t_title) { t('activerecord.attributes.donation.title') }
  given(:t_description) { t('activerecord.attributes.donation.description') }
  given(:t_submit) { t('donations.form.submit', action: t('common.edit')) }
  given(:t_title_eror) do
    "#{t('activerecord.attributes.donation.title')}
    #{t('activerecord.errors.messages.blank')}"
  end
  given(:t_description_eror) do
    "#{t('activerecord.attributes.donation.description')}
    #{t('activerecord.errors.messages.blank')}"
  end
  given(:user) { create :user }
  given(:admin) { create :user, role: :admin }
  given(:donation) { create :donation, user: user }
  given(:donation_another_user) { create :donation }

  describe 'Unauthenticated user' do
    scenario 'can not edit donation' do
      visit donation_path(donation)
      expect(page).to_not have_link t_edit
    end
  end

  describe 'Authenticated user without role' do
    before { sign_in user }

    describe 'try to edit own donation' do
      before do
        visit donation_path(donation)
        click_on t_edit
      end

      scenario 'with valid params' do
        fill_in t_title, with: 'Edited donation title'
        fill_in t_description, with: 'Edited donation description'
        click_on t_submit
        expect(page).to have_content 'Edited donation title'
        expect(page).to have_content 'Edited donation description'
        expect(page).to_not have_content donation.title
        expect(page).to_not have_content donation.description
      end

      scenario 'with invalid params' do
        fill_in t_title, with: nil
        fill_in t_description, with: nil
        click_on t_submit
        expect(page).to have_content t_title_eror
        expect(page).to have_content t_description_eror
      end
    end

    describe 'can not edit donation another user' do
      scenario 'user not sees link to edit' do
        visit donation_path(donation_another_user)
        expect(page).to_not have_link t_edit
      end
    end
  end

  describe 'User with role :admin' do
    before { sign_in admin }
    scenario 'can edit donation another user' do
      visit donation_path(donation)
      click_on t_edit
      fill_in t_title, with: 'Admin edited donation title'
      fill_in t_description, with: 'Admin edited donation description'
      click_on t_submit
      expect(page).to have_content 'Admin edited donation title'
      expect(page).to have_content 'Admin edited donation description'
      expect(page).to_not have_content donation.title
      expect(page).to_not have_content donation.description
    end
  end
end
