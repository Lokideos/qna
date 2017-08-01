class AnswersController < ApplicationController
  before_action :set_answer, only: [:edit, :update, :destroy]
  before_action :set_question

  def edit; end

  def create    
    @answer = @question.answers.new(answer_params)
    @answer.user_id = current_user.id
    
    if @answer.save
      redirect_to question_path(@question)
    else
      render "questions/show"
    end
  end

  def update
    if @answer.update(answer_params)
      redirect_to question_path(@question)
    else
      render "questions/show"
    end
  end

  def destroy
    if User.author_of?(current_user, @answer)
      @answer.destroy

      redirect_to question_path(@question)
    else
      render "questions/show"
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
