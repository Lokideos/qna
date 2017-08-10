class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: [:update, :destroy]
  before_action :set_question, only: [:create]

  def create    
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user    
    if @answer.save
      flash.now[:notice] = "Answer was created."    
    else
      flash.now[:notice] = "Answer was not created."
    end
  end

  def update
    @question = @answer.question
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
      flash.now[:notice] = "Answer was updated."
    else
      flash.now[:notice] = "Answer was not updated."
    end
  end

  def destroy
    @question = @answer.question
    if current_user.author_of?(@answer)
      @answer.destroy
      flash.now[:notice] = "Answer was deleted."
    else
      flash.now[:notice] = "Answer was not deleted."
    end
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

end
