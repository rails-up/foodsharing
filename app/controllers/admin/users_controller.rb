module Admin
  class UsersController < AdminController
    before_action :set_user, only: [:edit, :update]
    def index
      @users = User.all
    end

    def edit
    end

    def update
      if @user.update(user_params)
        redirect_to admin_users_path
      else
        render 'edit'
      end
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      # Check if any roles
      params[:user][:role_ids] ||= []
      params.require(:user).permit(:full_name, role_ids: [])
    end
  end
end
