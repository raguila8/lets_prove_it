class SessionsController < Devise::SessionsController
  before_action :failed_login_message, only: [:new]
  after_action :welcome_message, only: [:create]

  private

    # change flash type to error instead of alert
    def failed_login_message
      if failed_login?
        flash.now[:failed_login] = flash[:alert]
        flash.now[:alert] = nil
      end
    end

    def failed_login?
      puts request.env["warden.options"]
      (options = request.env["warden.options"]) && options[:action] == "unauthenticated"
    end

    def welcome_message
      flash[:notice] = "Welcome Back #{current_user.name ? current_user.name : current_user.username}!"
    end
end
