class Donation < ApplicationRecord
  resourcify
  include Authority::Abilities # updatable_by?

  belongs_to :user
  belongs_to :place

  validates  :title, :description, :user_id, presence: true

  default_scope { order(created_at: :desc) }

  before_create :set_special

  private

  def set_special
    self.special = true if user.has_role? :cafe
  end
end
