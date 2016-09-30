class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # Devise
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # Devise
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:full_name])
  end
end
