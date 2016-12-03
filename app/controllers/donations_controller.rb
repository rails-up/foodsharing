class DonationsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :load_donation, only: [:show, :edit, :update, :destroy]
  before_action :authorize_donation, only: [:show, :edit, :destroy]

  def index
    if current_user.present? && current_user.can_specialize?(Donation, action_name)
      @donations = Donation.all
    else
      @donations = Donation.where(special: false)
    end
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
    authorize_donation
    if @donation.save
      redirect_to @donation
    else
      render :new
    end
  end

  def update
    @donation.attributes = donation_params
    authorize_donation
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
    params.require(:donation).permit(:title, :description, :special, :city_id )
  end

  def authorize_donation
    authorize_action_for @donation
  end
end
