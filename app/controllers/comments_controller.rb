# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_association, only: [:create]
  after_action :publish_comment, only: [:create]

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      render json: @comment
    else
      render json: @comment.errors.full_messages
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def load_association
    @commentable = Question.find(params[:question_id]) if params[:question_id].present?
    @commentable = Answer.find(params[:answer_id]) if params[:answer_id].present?
  end

  def publish_comment
    return if @comment.errors.any?

    data = {
      commentable_id: @comment.commentable_id,
      commentable_type: @comment.commentable_type.underscore,
      comment_user_id: @comment.user.id,
      comment: @comment
    }

    ActionCable.server.broadcast(
      "comments_for_#{@comment.commentable_type == 'Question' ? @commentable.id : @commentable.question_id}",
      data
    )
  end
end
