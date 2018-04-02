class ConfirmationsController < Devise::ConfirmationsController

  def after_confirmation_path_for(resource_name, resource)
     sign_in(@user)
     flash[:success] = "You've been successfully authenticated."
     root_path
  end
end