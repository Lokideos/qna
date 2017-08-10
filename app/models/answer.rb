class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user  

  validates :body, presence: true
  validate :only_one_answer_can_be_best

  def choose_best_answer(answer)
    question = answer.question
    Answer.transaction do
      if question.answers.exists?(best_answer: true)
        old_answer = question.answers.find_by(best_answer: true)
        old_answer.best_answer = false
      end
      
      answer.update(best_answer: true)
    end
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
