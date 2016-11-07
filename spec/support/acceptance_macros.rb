module AcceptanceMacros
  def sign_in(user)
    visit new_user_session_path
    fill_in t('activerecord.attributes.user.email'), with: user.email
    fill_in t('activerecord.attributes.user.password'), with: user.password
    click_on t('devise.sessions.new.sign_in')
  end

  def sign_out
    within("nav.navbar") do
      click_on t('layouts.navlink.sign_out')
    end
  end
end
