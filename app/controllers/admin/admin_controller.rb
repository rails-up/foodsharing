module Admin
  class AdminController < ApplicationController
    before_action :authenticate_user!
    before_action :check_admin
    layout 'admin'
    protect_from_forgery with: :exception

    def dashboard
      @users_count = User.count
      @articles_count = Article.count
      @articles_count_today = Article.where("created_at >= ?", Time.zone.now.beginning_of_day).count
      @donations_count = Donation.count
      @donations_count_today = Donation.where("created_at >= ?", Time.zone.now.beginning_of_day).count
    end

    private

    def check_admin
      flash[:notice] = I18n.t('alerts.access_denied')
      redirect_to root_path unless current_user.has_role?(:admin)
    end
  end
end
