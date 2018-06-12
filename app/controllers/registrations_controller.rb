class RegistrationsController < Devise::RegistrationsController
  include ApplicationHelper
  #before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :configure_permitted_parameters, only: [:create]

  # inherit form devise controller
  def create
    super
  end

  protected
=begin
    def after_sign_up_path_for(resource)
      countdowns_path
    end

    def after_update_path_for(resource)
      user_path(resource)
    end
=end
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email, :password, :password_confirmation])
    end

  private
 
    def user_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation)
    end
end
