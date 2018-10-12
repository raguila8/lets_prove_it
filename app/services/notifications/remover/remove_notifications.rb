module Notifications
  module Remover
    class RemoveNotifications
      def initialize(params)
        notification_type = params[:notification_type]

        if notification_type == :upvote
          @notifications_remover = RemoveUpvoteNotifications.new(params)
        end
      end

      def call
        @notifications_remover.call
      end

      private
 
    end
  end
end
