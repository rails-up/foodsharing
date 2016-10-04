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
  given(:donation) { create :donation }

  scenario 'try to edit donation with valid params' do
    visit donation_path(donation)
    click_on t_edit
    fill_in t_title, with: 'Edited donation title'
    fill_in t_description, with: 'Edited donation description'
    click_on t_submit
    expect(page).to have_content 'Edited donation title'
    expect(page).to have_content 'Edited donation description'
    expect(page).to_not have_content donation.title
    expect(page).to_not have_content donation.description
  end

  scenario 'try to edit donation with invalid params' do
    visit donation_path(donation)
    click_on t_edit
    fill_in t_title, with: nil
    fill_in t_description, with: nil
    click_on t_submit
    expect(page).to have_content t_title_eror
    expect(page).to have_content t_description_eror
  end
end
