require_relative '../acceptance_helper'

feature 'User authentication', %q(
  In order to be able to create donation
  As an user
  I want to be able to registrations.
) do

  given!(:user) { create(:user) }

  scenario 'Any user try to register' do
    visit root_path
    within('.side-nav') { click_on 'Вход' }
    click_on 'Sign up'

    fill_in 'Full name', with: 'my full name'
    fill_in 'Email', with: 'test-mail@mail.com'
    fill_in 'Password', with: '12345678', match: :prefer_exact
    fill_in 'Password confirmation', with: '12345678'
    # fill_in 'user_password_confirmation', with: '12345678'

    click_on 'Sign up'
    expect(page).to have_content 'A message with a confirmation link has been
    sent to your email address.'
  end

  scenario 'Registered user try to sign in' do
    sign_in user
    expect(page).to have_content 'Signed in successfully.'
    expect(page).to have_content user.email
    expect(current_path).to eq root_path
  end

  scenario 'Non-registered user try to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'bad-mail@mail.com'
    fill_in 'Password', with: 'bad-password'
    click_on 'Log in'
    expect(page).to have_content 'Invalid Email or password.'
    expect(current_path).to eq new_user_session_path
  end

  scenario 'Registered user try logout' do
    sign_in(user)
    within('.side-nav') { click_on 'Выход' }
    expect(page).to have_content 'Signed out successfully.'
  end
end
