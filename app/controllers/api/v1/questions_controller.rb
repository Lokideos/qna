class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :load_question, only: [:show, :show_answers]
  
  authorize_resource

  def index
    @questions = Question.all
    respond_with @questions
  end

  def show
    respond_with @question, serializer: QuestionWoAnswerSerializer
  end

  def create
    @question = Question.create(question_params.merge(user: current_resource_owner))
    respond_with @question
  end

  def show_answers
    respond_with @question.answers
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end