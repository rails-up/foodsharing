class Donation < ApplicationRecord
  resourcify
  include Authority::Abilities #updatable_by?
  belongs_to :user
  validates :title, :description, :user_id, presence: true
  has_many :activities, dependent: :destroy
end
