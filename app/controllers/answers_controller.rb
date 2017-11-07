# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: %i[update destroy choose_best]
  before_action :set_question, only: [:create]
  before_action :set_associated_question, only: %i[update destroy choose_best]
  after_action :publish_answer, only: [:create]

  include Rated

  respond_to :js

  def create    
    @answer = current_user.answers.create(answer_params.merge(question_id: @question.id))
    respond_with(@answer)
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
      respond_with @answer
    else
      render :update
    end
  end

  def destroy
    respond_with(@answer.destroy) if current_user.author_of?(@answer)
  end

  def choose_best
    if current_user.author_of?(@question)
      @answer.choose_best_answer(@answer)
      render :choose_best
    end
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_associated_question
    @question = @answer.question
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: %i[id file _destroy])
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast("question_#{@answer.question.id}", @answer.prepare_data) if @answer.valid?
  end
end
