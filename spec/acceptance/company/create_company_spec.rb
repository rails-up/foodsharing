require_relative '../acceptance_helper'

feature 'Create Company', %q(
  In order to donate food from cafe/restaurant
  I want to be able to create Company
) do

  given(:t_company_name) { I18n.t('.activerecord.attributes.company.name') }
  given(:t_company_phone) { I18n.t('.activerecord.attributes.company.phone') }
  given(:t_company_address) { I18n.t('.activerecord.attributes.company.address') }
  given(:t_company_section) { I18n.t('.company_section') }
  given(:t_section_company_name) { I18n.t('.devise.registrations.edit.company_name') }
  given(:t_company_submit_btn) { I18n.t('common.save') }
  given(:t_add_company_link) { I18n.t('.devise.registrations.edit.add_company_link') }
  given(:t_edit_company_link) { I18n.t('.devise.registrations.edit.edit_company_link') }
  given(:t_delete_company_link) { I18n.t('common.destroy') }
  given(:t_company_name_error) do
    "#{t_company_name}
    #{t('activerecord.errors.messages.blank')}"
  end
  given(:t_company_phone_error) do
    "#{t_company_phone}
    #{t('activerecord.errors.messages.blank')}"
  end
  given(:t_company_address_error) do
    "#{t_company_address}
    #{t('activerecord.errors.messages.blank')}"
  end
  given(:user) { create(:user) } # FactoryGirl.create

  describe 'Unauthenticated user' do
    scenario 'does not have access to company profile' do
      visit edit_user_registration_path
      expect(page).to_not have_link t_company_section
    end
  end

  describe 'Authentitcated user without role' do
    before do
      sign_in user
      visit edit_user_registration_path
    end

    scenario 'tries to create company' do
      click_on t_add_company_link
      fill_in t_company_name, with: 'New company'
      fill_in t_company_phone, with: '123456789'
      fill_in t_company_address, with: 'Some streeet, 10'
      click_on t_company_submit_btn
      expect(page).to have_content t_section_company_name
      expect(page).to have_link(t_edit_company_link)
      expect(page).to have_link(t_delete_company_link)
    end

    scenario 'tries to create invalid company' do
      click_on t_add_company_link
      fill_in t_company_name, with: nil
      fill_in t_company_phone, with: nil
      fill_in t_company_address, with: nil
      click_on t_company_submit_btn
      expect(page).to have_content t_company_name_error
      expect(page).to have_content t_company_phone_error
      expect(page).to have_content t_company_address_error
    end
  end
end
