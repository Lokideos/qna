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
        old_answer.update(best_answer: false)
      end
      
      answer.update(best_answer: true)
    end
  end

  private

  def only_one_answer_can_be_best
    if self.question.answers.where(best_answer: true).length > 1
      errors.add(:best_answer, "have to be unique for each question")
    end    
  end
end
