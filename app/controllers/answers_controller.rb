class AnswersController < ApplicationController
  before_action :answer_params, only: [:show, :edit]
  def index
    @answers = Answer.all
  end

  def show; end

  def edit; end

  private

  def answer_params
    @answer = Answer.find(params[:id])
  end  
end
