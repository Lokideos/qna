class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: [:edit, :update, :destroy]
  before_action :set_question

  def edit; end

  def create    
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    
    if @answer.save
      flash[:success] = "Answer was created."
      redirect_to question_path(@question)
    else
      redirect_to question_path(@question)
      flash[:error] = error_msg(@answer)
    end
  end

  def update
    if @answer.update(answer_params)
      flash[:success] = "Answer was updated."
      redirect_to question_path(@question)
    else
      redirect_to question_path(@question)
      flash[:error] = error_msg(@answer)
    end
  end

  def destroy
    if User.author_of?(current_user, @answer)
      @answer.destroy
      flash[:success] = "Answer was deleted."
      redirect_to question_path(@question)
    else
      redirect_to question_path(@question)
      flash[:error] = error_msg(@answer)
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

  def error_msg(item)
    "Data for your answer contained #{item.errors.count} error: #{item.errors.full_messages.join(', ')}"
  end

end
