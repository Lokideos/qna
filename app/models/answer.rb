# frozen_string_literal: true

class Answer < ApplicationRecord
  include Ratable
  include Commentable

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

  def prepare_attachments
    attachments.map { |a| { id: a.id, file_url: a.file.url, file_name: a.file.identifier } }
  end

  def self.send_notification_to_subscribers(answer)
    question = answer.question
    question.subscriptions.each do |subscription|
      NotificationMailer.notification(question, subscription.user).deliver_later
    end
  end

  def prepare_data
    {
      answer: self,
      answer_user_id: user.id,
      question_id: question.id,
      question_user_id: question.user_id,
      answer_attachments: prepare_attachments,
      sum_ratings: ratings.sum(:value)
    }
  end

  private

  def only_one_answer_can_be_best
    if question && question.answers.where(best_answer: true).length > 1
      errors.add(:best_answer, 'have to be unique for each question')
    end
  end
end
