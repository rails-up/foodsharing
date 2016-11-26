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
  has_many :authorizations, dependent: :destroy

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization
    email = auth.info[:email]
    user = User.find_by(email: email)
    unless user
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email,
                          full_name: auth.info[:name],
                          password: password,
                          password_confirmation: password,
                          confirmed_at: Time.zone.now)
    end
    user.authorizations.create(provider: auth.provider, uid: auth.uid)
    user
  end

  def self.credentials_valid?(auth)
    auth.try(:provider) &&
      auth.try(:uid) &&
      auth.try(:info) &&
      auth.info.try(:[], :email) &&
      auth.info.try(:[], :name)
  end
end
