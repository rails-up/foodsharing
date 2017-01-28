class Donation < ApplicationRecord
  resourcify
  include Authority::Abilities # updatable_by?
  belongs_to :user
  validates :title, :description, :user_id, presence: true
  default_scope { order(created_at: :desc) }
end
