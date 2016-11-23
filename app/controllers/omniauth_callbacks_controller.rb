class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def vkontakte
    render json: request.env['omniauth.auth']

  end
end