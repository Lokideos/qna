# frozen_string_literal: true

class Question < ApplicationRecord
  include Ratable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  belongs_to :user

  validates :title, :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  def self.new_questions
    Question.where(["created_at > ?", Time.now - 86400])
  end

  def self.new_questions_titles
    titles = []
    new_questions.each { |question| titles << question.title }
    titles
  end
end
