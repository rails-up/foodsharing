class Company < ApplicationRecord
  resourcify
  include Authority::Abilities
  belongs_to :user
  validates :name, presence: true, uniqueness: true
  validates :phone, :address, :user_id, presence: true

  after_create :add_role_to_user

  private

  def add_role_to_user
    user.add_role(:cafe)
  end
end
