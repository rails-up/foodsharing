class CompaniesController < ApplicationController
  def new
    @user = User.find(session[:user_id])
    @company = @user.build_company
  end

  def create
    @user = User.find(session[:user_id])
    @company = @user.build_company(companies_params)
    if @company.save
      redirect_to root_path
      session[:user_id] = nil
    else
      render :new
    end
  end

  private

  def companies_params
    params.require(:company).permit(:name, :phone, :address)
  end
end
