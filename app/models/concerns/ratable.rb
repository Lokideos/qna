module Ratable
  extend ActiveSupport::Concern

  included do
    has_many :ratings, as: :ratable, dependent: :destroy

    def add_rating(user)
      rate = self.ratings.where(user: user).first

      if rate
        rate.update!(value: 1)
      else
        ratings.create!(value: 1, user: user)
      end
    end

    def decrease_rating(user)
      rate = self.ratings.where(user: user).first

      if rate
        rate.update!(value: -1)
      else
        ratings.create!(value: -1, user: user)
      end
    end

  end
end