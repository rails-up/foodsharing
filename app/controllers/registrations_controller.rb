class RegistrationsController < Devise::RegistrationsController
  protected

  def after_inactive_sign_up_path_for(resource)
    session[:user_id] = resource.id
    params['company'].nil? ? root_path : new_company_path
  end
end
