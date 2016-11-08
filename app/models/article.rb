class Article < ApplicationRecord
  resourcify
  include Authority::Abilities # updatable_by?
  belongs_to :user
  validates :title, :content, :user, presence: true
  enum status: [:draft, :published]
end
