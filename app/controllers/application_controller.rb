class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # Devise
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # Devise
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:full_name])
  end

  def authority_forbidden(error)
    # Authority.logger.warn(error.message)
    redirect_to request.referrer.presence || root_path, alert: t('common.not_allowed')
  end

  def auth_current_user
    current_user || User.new
  end
end
