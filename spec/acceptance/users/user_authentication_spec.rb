require_relative '../acceptance_helper'

feature 'User authentication', %q(
  In order to be able to create donation
  As an user
  I want to be able to registrations.
) do

  given(:t_full_name) { t('activerecord.attributes.user.full_name') }
  given(:t_email) { t('activerecord.attributes.user.email') }
  given(:t_password) { t('activerecord.attributes.user.password') }
  given(:t_password_confirmation) do
    t('activerecord.attributes.user.password_confirmation')
  end
  given!(:user) { create(:user) }

  scenario 'Any user try to register' do
    visit root_path
    within('.side-nav') { click_on t('layouts.navlink.sign_in') }
    click_on t('devise.common.sign_up')

    fill_in t_full_name, with: 'my full name'
    fill_in t_email, with: 'test-mail@mail.com'
    fill_in t_password, with: '12345678', match: :prefer_exact
    fill_in t_password_confirmation, with: '12345678'

    click_on t('devise.registrations.new.sign_up')
    expect(page).to have_content t('devise.registrations.signed_up_but_unconfirmed')
  end

  scenario 'Registered user try to sign in' do
    sign_in user
    expect(page).to have_content t('devise.sessions.signed_in')
    expect(page).to have_content user.email
    expect(current_path).to eq root_path
  end

  scenario 'Non-registered user try to sign in' do
    visit new_user_session_path
    fill_in t_email, with: 'bad-mail@mail.com'
    fill_in t_password, with: 'bad-password'
    click_on t('devise.sessions.new.sign_in')
    expect(page).to have_content t('devise.failure.invalid', authentication_keys: t_email)
    expect(current_path).to eq new_user_session_path
  end

  scenario 'Registered user try logout' do
    sign_in(user)
    within('.side-nav') { click_on t('layouts.navlink.sign_out') }
    expect(page).to have_content t('devise.sessions.signed_out')
  end
end
