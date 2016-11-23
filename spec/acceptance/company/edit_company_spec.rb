require_relative '../acceptance_helper'

feature 'Edit Company', %q(
  In order to edit company attributes
  I want to be able to edit Company
) do

  given(:t_company_name) { I18n.t('.activerecord.attributes.company.name') }
  given(:t_company_phone) { I18n.t('.activerecord.attributes.company.phone') }
  given(:t_company_address) { I18n.t('.activerecord.attributes.company.address') }
  given(:t_company_header) { I18n.t('.company.edit.title') }
  given(:t_section_company_name) { I18n.t('.devise.registrations.edit.company_name') }
  given(:t_company_submit_btn) { I18n.t('common.save') }
  given(:t_edit_company_link) { I18n.t('.devise.registrations.edit.edit_company_link') }
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
  given(:company) { create :company, user: user }
  given(:another_user) { create(:user) } # FactoryGirl.create
  given(:another_company) { create :company, user: another_user }

  describe 'Unauthenticated user' do
    scenario 'can not edit company' do
      visit edit_user_registration_path
      expect(page).to_not have_link t_edit_company_link
    end
  end

  describe 'Authenticated user with role' do
    before do
      company
      sign_in user
    end

    describe 'tries to edit his own company' do
      before do
        visit edit_user_registration_path
        click_on t_edit_company_link
      end

      scenario 'with valid params' do
        fill_in t_company_name, with: 'Edited company'
        fill_in t_company_phone, with: '987654321'
        fill_in t_company_address, with: 'Some edited streeet, 10'
        click_on t_company_submit_btn
        expect(page).to have_content t_section_company_name
        expect(page).to have_content 'Edited company'
      end

      scenario 'with invalid params' do
        fill_in t_company_name, with: nil
        fill_in t_company_phone, with: nil
        fill_in t_company_address, with: nil
        click_on t_company_submit_btn
        expect(page).to have_content t_company_name_error
        expect(page).to have_content t_company_phone_error
        expect(page).to have_content t_company_address_error
      end
    end

    describe 'can not edit company of another user' do
      before { another_company }
      scenario 'user does not see link to edit' do
        visit edit_company_path(another_company)
        expect(page).to_not have_content t_company_header
      end
    end
  end
end
