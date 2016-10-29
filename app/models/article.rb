class Article < ApplicationRecord
  validates :title, :content, :user, presence: true
  enum status: [:draft, :published]

  belongs_to :user

end
