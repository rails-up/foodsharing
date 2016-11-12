class Article < ApplicationRecord
  resourcify
  include Authority::Abilities # updatable_by?
  belongs_to :user
  validates :title, :content, :user, presence: true
  enum status: [:draft, :published]

  default_scope { order(updated_at: :desc) }
  scope :published, -> { where(status: :published).order(updated_at: :desc) }
  scope :draft, -> { where(status: :draft).order(updated_at: :desc) }
end
