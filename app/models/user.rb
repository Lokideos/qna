# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable, omniauth_providers: [:facebook, :twitter]

  has_many :answers, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :authorizations

  def author_of?(item)
    id == item.user_id
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email]
    if email
      user = User.where(email: email).first
      if user
        user.create_authorization(auth)
      else
        password = Devise.friendly_token[0, 20]
        user = User.create!(email: email, password: password, password_confirmation: password, confirmed_at: Time.now)
        user.create_authorization(auth)
      end
    else
      password = Devise.friendly_token[0,20]
      email_part = Devise.friendly_token[0,8]
      email = "#{email_part}@example.com"
      user = User.new(email: email, password: password, password_confirmation: password)
    end

    user
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
