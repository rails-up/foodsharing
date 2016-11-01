class Donation < ApplicationRecord
  belongs_to :user
  validates :title, :description, :user_id, presence: true
end
