class Api::V1::AnswersController < Api::V1::BaseController
  before_action :load_answer
  before_action :load_associated_question

  authorize_resource

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
end