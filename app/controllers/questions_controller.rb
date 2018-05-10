# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy]
  after_action :publish_question, only: [:create]
  before_action :set_current_user, only: [:index]
  before_action :build_answer, only: [:show]
  after_action only: [:create] { subscribe(@question.user) }

  include Rated

  authorize_resource

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with @question
  end

  def new
    respond_with(@question = Question.new)
  end

  def edit; end

  def create
    respond_with @question = current_user.questions.create(question_params)
  end

  def update
    if correct_user?(@question)
      @question.update(question_params)
      respond_with @question
    else
      render :index
    end
  end

  def destroy
    if correct_user?(@question)
      respond_with(@question.destroy)
    else
      render :index
    end
  end

  private

  def subscribe(user)
    @question.add_subscription(user)
  end

  def correct_user?(question)
    current_user.author_of?(question)
  end

  def build_answer
    @answer = @question.answers.build
  end

  def set_current_user
    @current_user = current_user
  end

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: %i[id file _destroy])
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'questions',

      ApplicationController.render(json: @question)
    )
  end
end
