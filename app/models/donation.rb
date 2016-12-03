class Donation < ApplicationRecord
  resourcify
  include Authority::Abilities # updatable_by?
  belongs_to :user
  belongs_to :city
  validates :title, :description, :user_id, :city, presence: true
end
