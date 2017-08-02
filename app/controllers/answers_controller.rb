class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: [:edit, :update, :destroy]
  before_action :set_question

  def edit; end

  def create    
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    
    if @answer.save
      flash[:success] = "Answer was created."
      redirect_to question_path(@question)
    else
      render 'questions/show'
    end
  end

  def update
    if @answer.update(answer_params)
      flash[:success] = "Answer was updated."
      redirect_to question_path(@question)
    else
      render 'questions/show'
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:success] = "Answer was deleted."
      redirect_to question_path(@question)
    else
      render 'questions/show'
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
