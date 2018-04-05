module DeviseHelpers
  def self.skip_authorization
    [
      Devise::SessionsController,
      Devise::RegistrationsController,
      Devise::ConfirmationsController,
      Devise::OmniauthCallbacksController,
      Devise::PasswordsController
    ].each do |controller|
      controller.skip_authorization_check
    end
  end

  self.skip_authorization
end