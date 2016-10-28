class Article < ApplicationRecord
  validates :title, :content, presence: true
  enum status: [:draft, :published]
end
