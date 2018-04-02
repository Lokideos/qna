class EmailOauthAssignersController < ApplicationController
  def find_email; end

  def check_email
    @email = params[:email]
    @user = User.where(email: @email).first
    unless @user
      password = Devise.friendly_token[0, 20]
      User.create!(email: @email, password: password, password_confirmation: password)
      @user = User.where(email: @email).first
      @user.authorizations.create(provider: session['device.provider'], uid: session['device.uid'])
      flash[:success] = "Please confirm your email. Then you will be able to authenticate using your twitter account."
      redirect_to root_path
    end
  end

  def assign_oauth_authorization
    @email = params[:email]
    @password = params[:password]

    @user = User.where(email: @email).first
    if @user.valid_password?(@password)
      @user.authorizations.create(provider: session['device.provider'], uid: session['device.uid'])
      flash[:success] = "Successfully authenticated from Twitter account."
      sign_in_and_redirect @user, event: :authentication
    end
  end
end