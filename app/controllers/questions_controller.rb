class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def edit
    if current_user.author_of?(@question)
      @question.attachments.build
    end
  end

  def create
    @question = Question.create(question_params)
    @question.user_id = current_user.id

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update   
    if current_user.author_of?(@question)
      if @question.update(question_params)
        redirect_to @question
      else
        render :edit
      end
    else
      render :index
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy

      redirect_to questions_path
    else
      render :index
    end
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end
end
