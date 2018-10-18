module Notifications
  module Sender
    class SendProblemNotifications
      def initialize
        @notification_type = params[:notification_type]
        @version = params[:resource]
        @sent = 0
        if params[:options]
          @options = params[:options]
        end
      end

      def call
        send_deleted_version_notifications
        return { response: :success, sent: @sent }
      end

      private

        def send_deleted_problem_notifications
          action = (@version.versioned.class.name == "Proof" ? "removed your edit (version #{@version.version_number}) on a proof for " : "removed your edit on")
          n = Notification.new(actor_id: -1, recipient: @version.user, 
                               action: action, notifiable: @version, 
                               action_type: "deletion", 
                               details: @options[:deleted_for])
          n.save(validate: false)
          @sent += 1 
        end
    end
  end
end
