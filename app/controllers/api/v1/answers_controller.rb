class Api::V1::AnswersController < Api::V1::BaseController
  before_action :load_answer, only: [:show]
  before_action :load_associated_question, only: [:show]
  before_action :load_associated_question_for_index, only: [:index]

  authorize_resource

  def index
    respond_with @question.answers
  end

  def show
    respond_with @answer
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_associated_question
    @question = @answer.question
  end

  def load_associated_question_for_index
    @question = Question.find(params[:question_id])
  end
end