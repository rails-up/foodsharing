class User < ApplicationRecord
  rolify
  include Authority::UserAbilities # can_update?
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable, :omniauthable,
         omniauth_providers: [:vkontakte]

  validates :full_name, presence: true
  has_many :articles
  has_many :donations, dependent: :destroy
  has_one :company, dependent: :destroy
end
