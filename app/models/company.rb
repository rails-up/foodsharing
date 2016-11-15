class Company < ApplicationRecord
  has_many :users
  validates :name, :phone, :address, presence: true
end
