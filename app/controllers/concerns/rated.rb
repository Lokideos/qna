# frozen_string_literal: true

module Rated
  extend ActiveSupport::Concern

  included do
    before_action :set_item, only: %i[rate_good rate_bad cancel_rate]
  end

  def rate_good
    unless current_user.author_of?(@item)
      @item.add_rating(current_user)
      rate_responde
    end
  end

  def rate_bad
    unless current_user.author_of?(@item)
      @item.decrease_rating(current_user)
      rate_responde
    end
  end

  def cancel_rate
    if @item.ratings.find_by(user: current_user)
      @item.nullify_rating(current_user)
      rate_responde
    end
  end

  private

  def rate_responde
    respond_to do |format|
      format.json { render json: @item.ratings.sum(:value) }
    end
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_item
    @item = model_klass.find(params[:id])
  end
end
