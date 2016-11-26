class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def vkontakte
    unless User.credentials_valid?(auth)
      redirect_to new_user_session_path
      set_flash_message(:notice,
                        :failure,
                        kind: 'Vkontakte',
                        reason: t('devise.omniauth_callbacks.invalid_credentials')) if is_navigational_format?
      return
    end
    user = User.find_for_oauth(auth)
    sign_in_and_redirect user, event: :authentication
    set_flash_message(:notice, :success, kind: auth.provider.capitalize) if is_navigational_format?
  end

  private

  def auth
    request.env['omniauth.auth']
  end
end
