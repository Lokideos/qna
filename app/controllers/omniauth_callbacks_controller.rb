class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    authenticate_via_oauth('Facebook')
  end

  def twitter
    authenticate_via_oauth('Twitter')
  end

  private

  def authenticate_via_oauth(kind)
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
    else
      session['device.provider'] = request.env['omniauth.auth'].provider
      session['device.uid'] = request.env['omniauth.auth'].uid.to_s
      redirect_to find_email_email_oauth_assigner_path
    end
  end
end