class RegistrationsController < Devise::RegistrationsController
  include ApplicationHelper
  #before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :configure_permitted_parameters, only: [:create]
  before_action :authenticate_user!, only: [:update]


  # inherit form devise controller
  def create
    super
  end

  def update
    @user = current_user
    if @user.update_with_password(user_password_params)
      # Sign in the user by passing validation in case their password changed
      bypass_sign_in(@user)
    end
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

    def user_password_params
      params.require(:user).permit(:password, :password_confirmation, :current_password)
    end
end
