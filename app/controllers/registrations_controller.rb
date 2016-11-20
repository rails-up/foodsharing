class RegistrationsController < Devise::RegistrationsController
  protected

  def after_inactive_sign_up_path_for(resource)
    return root_path if params['company'].nil?
    session[:user_id] = resource.id
    new_company_path
  end
end
