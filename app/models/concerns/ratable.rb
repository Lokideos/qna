# frozen_string_literal: true

module Ratable
  extend ActiveSupport::Concern

  included do
    has_many :ratings, as: :ratable, dependent: :destroy

    def add_rating(user)
      rate = rating_current_user(user)

      if rate
        rate.update!(value: 1)
      else
        ratings.create!(value: 1, user: user)
      end
    end

    def decrease_rating(user)
      rate = rating_current_user(user)

      if rate
        rate.update!(value: -1)
      else
        ratings.create!(value: -1, user: user)
      end
    end

    def nullify_rating(user)
      rate = rating_current_user(user)

      rate&.destroy
    end

    def rating_current_user(user)
      ratings.where(user: user).first
    end
  end
end
