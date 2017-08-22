class Rating < ApplicationRecord
  belongs_to :ratable, polymorphic: true, optional: true
  belongs_to :user

  validates :value, presence: true
end
