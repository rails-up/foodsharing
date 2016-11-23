require_relative '../acceptance_helper'

feature 'Delete Company', %q(
  In order to delete company attributes
  I want to be able to delete Company
) do

  given(:t_section_company_name) { I18n.t('.devise.registrations.edit.company_name') }
  given(:t_delete_company_link) { I18n.t('common.destroy') }
  given(:user) { create(:user) } # FactoryGirl.create
  given(:company) { create :company, user: user }

  describe 'Unauthenticated user' do
    scenario 'can not delete company' do
      visit edit_user_registration_path
      expect(page).to_not have_link t_delete_company_link
    end
  end

  describe 'Authenticated user without role cafe' do
    scenario 'can not delete company' do
      visit edit_user_registration_path
      expect(page).to_not have_link t_delete_company_link
    end
  end

  describe 'Authenticated user with role cafe' do
    before do
      sign_in user
      company
    end
    scenario 'tries to delete his own company' do
      visit edit_user_registration_path
      within('.company_block') do
        click_on t_delete_company_link
      end
      expect(page).not_to have_content t_section_company_name
    end
  end
end
