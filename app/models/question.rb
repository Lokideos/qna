# frozen_string_literal: true

class Question < ApplicationRecord
  include Ratable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  belongs_to :user

  validates :title, :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  def add_subscription(user)
    Subscription.create!(question_id: self.id, user_id: user.id)
  end

  def self.new_questions
    where(["created_at > ?", Time.now - 86400]).order(created_at: :asc)
  end

  # Method below doesnt' work for Daily Mailer e-mail - I'm not sure why so far
  def self.new_questions_titles
    titles = []
    new_questions.each { |question| titles << question.title }
    titles
  end
end
