require_relative '../acceptance_helper'

feature 'OAuth authentication', %q(
  In order to be able to fast login
  As an user
  I want to be able to registrations thru social network.
) do

  given(:vk_sign_in) { "#{t('devise.common.omniauth_sign_in')} Vkontakte" }

  before do
    visit root_path
    within('nav.navbar') { click_on t('layouts.navlink.sign_in') }
  end

  describe 'User sign in with Vkontakte' do
    scenario 'with valid credentials' do
      mock_auth_hash :vkontakte
      click_on vk_sign_in
      expect(page).to have_content t('devise.omniauth_callbacks.success', kind: 'Vkontakte')
    end

    scenario 'with invalid credentials' do
      mock_auth_invalid :vkontakte
      click_on vk_sign_in
      expect(page).to have_content t('devise.omniauth_callbacks.invalid_credentials')
      expect(current_path).to eq new_user_session_path
    end
  end
end
