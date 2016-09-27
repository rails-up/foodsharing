class Donation < ApplicationRecord
  validates :title, :description, presence: true
end
