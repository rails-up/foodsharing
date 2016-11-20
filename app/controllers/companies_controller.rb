class CompaniesController < ApplicationController
  before_action :load_user, only: [:new, :create]
  before_action :load_company, only: [:edit, :update, :destroy]

  def new
    @company = @user.build_company
  end

  def create
    @company = @user.build_company(companies_params)
    if @company.save
      redirect_to edit_user_registration_path
      session[:user_id] = nil
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @company.update(companies_params)
      redirect_to edit_user_registration_path
    else
      render :edit
    end
  end

  def destroy
    @company.destroy
    redirect_to edit_user_registration_path
  end

  private

  def load_user
    @user = User.find(current_user || session[:user_id])
  end

  def load_company
    @company = Company.find(params[:id])
  end

  def companies_params
    params.require(:company).permit(:name, :phone, :address)
  end
end
