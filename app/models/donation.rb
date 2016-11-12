class Donation < ApplicationRecord
  resourcify
  include Authority::Abilities #updatable_by?
  belongs_to :user
  validates :title, :description, :user_id, presence: true
  has_many :activities, dependent: :destroy
  after_create { create_action 'all', 'create' }
  after_update { create_action 'visitor', 'update' }

  private

  def create_action(to, event)
    activity = user.activities.build
    activity.recipient = to
    activity.action = event
    activity.donation = self
    activity.save
  end

end
