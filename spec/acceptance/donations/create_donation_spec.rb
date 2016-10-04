require_relative '../acceptance_helper'

feature 'Create Donation', %q(
  In order to donate extra food
  I want to be able to create donation
) do

  given(:t_new) { t('donations.index.new') }
  given(:t_title) { t('activerecord.attributes.donation.title') }
  given(:t_description) { t('activerecord.attributes.donation.description') }
  given(:t_submit) { t('donations.form.submit', action: t('common.create')) }

  before { visit donations_path }

  scenario 'try create valid donation' do
    click_on t_new
    fill_in t_title, with: 'New donation title'
    fill_in t_description, with: 'New donation description'
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
end
