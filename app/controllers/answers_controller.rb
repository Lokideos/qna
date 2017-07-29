class AnswersController < ApplicationController
  before_action :set_answer, only: [:show, :edit, :update, :destroy]
  before_action :set_question, only: [:new, :create]
  before_action :set_question_for_del_and_edit, only: [:edit, :destroy]

  def index
    @answers = Answer.all
  end

  def show; end

  def new    
    @answer = Answer.new
  end

  def edit; end

  def create    
    @answer = @question.answers.new(answer_params)

    if @answer.save
      redirect_to question_path(@question)
    else
      render :new
    end
  end

  def update
    if @answer.update(answer_params)
      redirect_to question_path(@answer.question)
    else
      render :edit
    end
  end

  def destroy    
    @answer.destroy

    redirect_to question_path(@question)
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_question_for_del_and_edit
    @question = @answer.question
  end

  def answer_params
    params.require(:answer).permit(:body, :question_id, :user_id)
  end

end
