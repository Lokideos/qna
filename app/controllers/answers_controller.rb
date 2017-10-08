# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: %i[update destroy choose_best]
  before_action :set_question, only: [:create]
  before_action :set_associated_question, only: %i[update destroy choose_best]

  include Rated

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    flash.now[:notice] = if @answer.save
                           'Answer was created.'
                         else
                           'Answer was not created.'
                         end
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
      flash.now[:notice] = 'Answer was updated.'
    else
      flash.now[:notice] = 'Answer was not updated.'
      render :update
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash.now[:notice] = 'Answer was deleted.'
    else
      flash.now[:notice] = 'Answer was not deleted.'
    end
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
end
