class AnswersController < ApplicationController
  before_action :set_answer, only: [:show, :edit]
  def index
    @answers = Answer.all
  end

  def show; end

  def new
    @answer = Answer.new
  end

  def edit; end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end  
end
