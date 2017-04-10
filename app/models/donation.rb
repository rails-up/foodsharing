class Donation < ApplicationRecord
  resourcify
  include Authority::Abilities # updatable_by?

  belongs_to :user
  belongs_to :place

  validates  :title, :description, :user_id, presence: true

  default_scope { order(created_at: :desc) }

  before_create :set_special
  before_validation :set_place, on: [:create, :update]

  private

  def set_special
    self.special = true if user.has_role? :cafe
  end

  def set_place
    return unless place_id.nil?
    city = City.find_or_create_by(name: nil)
    place = Place.find_or_create_by(city_id: city.id, name: nil)
    self.place = place
  end
end
