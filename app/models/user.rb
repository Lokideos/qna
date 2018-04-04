# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable, omniauth_providers: [:facebook, :twitter]

  has_many :answers, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :authorizations, dependent: :destroy

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
        confirmed_at = auth.info[:new_user].present? ? nil : Time.now
        user = User.create!(email: email, password: password, password_confirmation: password, confirmed_at: confirmed_at)
        user.create_authorization(auth)
      end
    end

    user
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def self.find_by_email(email)
    user = User.where(email: email).first
  end
end
