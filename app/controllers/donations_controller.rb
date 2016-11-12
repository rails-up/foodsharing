class DonationsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :load_donation, only: [:show, :edit, :update, :destroy]
  before_action :authorize_donation, only: [:edit, :update, :destroy]
  # authorize_actions_for Donation, except: [:show, :index]
  before_action :set_activities, only: [:index]

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

  def authorize_donation
    authorize_action_for @donation
  end

  def set_activities
    if user_signed_in?
      @activities = Activity
        .where(recipient: [current_user.role, 'all'])
        .order(created_at: :desc)
        .limit(10)
    end
  end

end
