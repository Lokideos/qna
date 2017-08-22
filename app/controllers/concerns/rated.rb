module Rated
  extend ActiveSupport::Concern

  included do
    before_action :set_item, only: [:rate_good, :rate_bad]
  end

  def rate_good
    @item.add_rating(current_user)
    rate_responde(@item)
  end

  def rate_bad
    @item.decrease_rating(current_user)
    rate_responde(@item)
  end

  private

  def rate_responde(rated_item)
    respond_to do |format|
      format.json { render json: rated_item.ratings.sum(:value) }
    end
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_item
    @item = model_klass.find(params[:id])
  end
end