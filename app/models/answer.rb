class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user  

  validates :body, presence: true
  validate :only_one_answer_can_be_best

  def choose_best_answer(answer)
    question = answer.question
    question.answers.each do |answer|
        answer.update(best_answer: false)
    end
    answer.update(best_answer: true)
  end

  private

  def only_one_answer_can_be_best
    best_answers = 0

    self.question.answers.each do |answer|
      best_answers += 1 if answer.best_answer == true
    end

    if best_answers > 1
      errors.add(:best_answer, "have to be unique for each question")
    end
  end
end
