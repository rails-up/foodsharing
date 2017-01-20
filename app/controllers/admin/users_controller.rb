module Admin
  class UsersController < AdminController
    before_action :set_user, only: [:edit, :update]
    def index
      @users = User.all
    end

    def edit
    end

    def update
      # @user_role = Role.find(params[:user][:role_ids])
      # @user.add_role @user_role.name
      # redirect_to admin_users_path
      params[:user][:role_ids] ||= []
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
      params.require(:user).permit(:full_name, role_ids: [])
    end
  end
end
