class RegistrationsController < Devise::RegistrationsController

  def edit
    self.resource.company ||= Company.new
    render :edit
  end

  private

  def account_update_params
    params.require(:user).permit(:full_name, :email, :password, :password_confirmation, :current_password,
                                 company_attributes: [:id, :name, :phone, :address])
  end
end