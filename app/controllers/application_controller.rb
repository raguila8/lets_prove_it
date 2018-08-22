class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

    # Before action
    # Confirms the correct user
    def correct_user
      @user = User.find(params[:id])
      if @user != current_user
        flash[:alert] = "Action not authorized"
        redirect_to(root_url)
      end
    end

    def logged_in_user
      unless signed_in?
        flash[:alert] = "You need to sign in or sign up before continuing."
        redirect_to new_user_session_path
      end
    end

end
