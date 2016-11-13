class Article < ApplicationRecord
  resourcify
  include Authority::Abilities # updatable_by?
  belongs_to :user
  enum status: { draft: 0, published: 1 }
  validates :title, :content, :user, presence: true

  default_scope { order(updated_at: :desc) }
  scope :published, -> { where(status: :published).order(updated_at: :desc) }
  scope :draft, -> { where(status: :draft).order(updated_at: :desc) }
end
