# frozen_string_literal: true

class Answer < ApplicationRecord
  include Ratable
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy

  validates :body, presence: true
  validate :only_one_answer_can_be_best

  def choose_best_answer(answer)
    question = answer.question
    Answer.transaction do
      if question.answers.exists?(best_answer: true)
        old_answer = question.answers.find_by(best_answer: true)
        old_answer.update!(best_answer: false)
      end

      answer.update!(best_answer: true)
    end
  end

  scope :ordered_by_creation, -> { order(created_at: :asc) }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  private

  def only_one_answer_can_be_best
    if question&.answers&.where(best_answer: true)&.length > 1
      errors.add(:best_answer, 'have to be unique for each question')
    end
  end
end
