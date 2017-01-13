module Admin
  class AdminController < ActionController::Base
    layout 'admin'
    protect_from_forgery with: :exception

    def dashboard
      @users_count = User.count
      @donations_count = Donation.count
    end
  end
end
