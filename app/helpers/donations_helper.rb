module DonationsHelper
  def current_place
    "г. #{@donation.place.city.name}, ст. м. #{@donation.place.name}"
  end
end
