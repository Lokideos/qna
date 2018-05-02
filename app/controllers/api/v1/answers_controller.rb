class Api::V1::AnswersController < Api::V1::BaseController
  before_action :load_answer, only: [:show]
  before_action :load_associated_question, only: [:show]
  before_action :load_associated_question_from_url, only: [:index, :create]

  authorize_resource

  def index
    respond_with @question.answers
  end

  def show
    respond_with @answer
  end

  def create
    @answer = current_resource_owner.answers.create(answer_params.merge(question_id: @question.id))
    render json: { answer: @answer }
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_associated_question
    @question = @answer.question
  end

  def load_associated_question_from_url
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end