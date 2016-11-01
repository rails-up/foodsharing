class DonationsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :load_donation, only: [:show, :edit, :update, :destroy]
  before_action :check_access, only: [:edit, :update, :destroy]

  def index
    @donations = Donation.all
  end

  def show
  end

  def new
    @donation = Donation.new
  end

  def edit
  end

  def create
    @donation = Donation.new(donation_params.merge(user: current_user))
    if @donation.save
      redirect_to @donation
    else
      render :new
    end
  end

  def update
    if @donation.update(donation_params)
      redirect_to @donation
    else
      render :edit
    end
  end

  def destroy
    @donation.destroy
    redirect_to donations_path
  end

  private

  def load_donation
    @donation = Donation.find(params[:id])
  end

  def donation_params
    params.require(:donation).permit(:title, :description)
  end

  def check_access
    not_allowed unless @donation.user == current_user
  end

  def not_allowed
    flash[:notice] = t('common.not_allowed')
    redirect_to donation_path(@donation)
  end
end
