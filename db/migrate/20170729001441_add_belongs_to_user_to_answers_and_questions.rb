class AddBelongsToUserToAnswersAndQuestions < ActiveRecord::Migration[5.1]
  def change
    add_belongs_to :answers, :user, index: true
    add_belongs_to :questions, :user, index: true
  end
end
