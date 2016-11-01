class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable, :omniauthable
  validates :full_name, presence: true
  enum role: [:visitor, :editor]
  has_many :articles
  has_many :donations, dependent: :destroy
end
