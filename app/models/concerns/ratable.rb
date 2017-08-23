module Ratable
  extend ActiveSupport::Concern

  included do
    has_many :ratings, as: :ratable, dependent: :destroy

    def add_rating(user)
      rate = rating?(user)

      if rate
        rate.update!(value: 1)
      else
        ratings.create!(value: 1, user: user)
      end
    end

    def decrease_rating(user)
      rate = rating?(user)

      if rate
        rate.update!(value: -1)
      else
        ratings.create!(value: -1, user: user)
      end
    end

    def nullify_rating(user)
      rate = rating?(user)

      if rate
        rate.destroy
      end
    end

    def rating?(user)
      self.ratings.where(user: user).first
    end

  end
end