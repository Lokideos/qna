class EmailOauthAssignersController < ApplicationController
  def find_email; end

  def check_email
    @email = params[:email]
    @auth = OmniAuth::AuthHash.new(provider: session['device.provider'], uid: session['device.uid'], info: { email: @email, new_user: true })
    @user = User.find_by_email(@email)
    User.find_for_oauth(@auth) unless @user
  end

  def assign_oauth_authorization
    @email = params[:email]
    @password = params[:password]
    @auth = OmniAuth::AuthHash.new(provider: session['device.provider'], uid: session['device.uid'])

    @user = User.find_by_email(@email)
    if @user.valid_password?(@password)
      @user.create_authorization(@auth)
      flash[:success] = "Successfully authenticated from Twitter account."
      sign_in_and_redirect @user, event: :authentication
    end
  end
end