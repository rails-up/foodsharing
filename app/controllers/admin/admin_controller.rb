module Admin
  class AdminController < ActionController::Base
    layout 'admin'
    protect_from_forgery with: :exception

    def dashboard
    end
  end
end
