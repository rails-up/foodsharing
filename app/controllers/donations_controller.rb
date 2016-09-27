class DonationsController < ApplicationController
  before_action :load_donation, only: [:show, :edit, :update, :destroy]

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
    @donation = Donation.new(donation_params)
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
end
