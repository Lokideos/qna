require 'application_responder'

# frozen_string_literal: true

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html, :js, :json

  protect_from_forgery with: :exception

  before_action :gon_user, unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_path, alert: exception.message }
      format.json { render json: exception.message, status: :forbidden }
      format.js { render json: exception.message, status: :forbidden }
    end
  end

  check_authorization

  private

  def gon_user
    gon.current_user_id = current_user.id if current_user
  end
end
