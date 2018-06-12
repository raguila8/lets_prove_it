class SessionsController < Devise::SessionsController
  before_action :failed_login_message, only: [:new]

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
end
