class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  has_many :suggest_products, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :comments, dependent: :destroy
  enum role: [:admin, :user]

  def self.from_omniauth auth
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email.nil? ?
        "#{auth.uid}@eco.com" : auth.info.email
      user.phone = auth.info.phone
      user.address = auth.info.address
      user.avatar = auth.info.image + "?type=large"
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name
      user.save!
    end
  end
end
