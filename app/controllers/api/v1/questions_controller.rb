class Api::V1::QuestionsController < Api::V1::BaseController
  load_and_authorize_resource

  def index
    @questions = Question.all
    respond_with @questions
  end

  def show
    respond_with @question, serializer: QuestionWoAnswerSerializer
  end

  def create
    @question = Question.create(question_params.merge(user: current_resource_owner))
    render json: { question: @question }
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end