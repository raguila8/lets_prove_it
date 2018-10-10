module Notifications
  module Sender
    class SendNotifications

      def initialize(params)
        notification_type = params[:notification_type]

        if notification_type == :upvote
          @notifications_sender = SendUpvoteNotifications.new(params)
        elsif [:new_comment, :updated_comment].include? notification_type
          @notifications_sender = SendCommentNotifications.new(params)
        end
      end

      def call
        @notifications_sender.call
        #send(@notification_type)
      end
    end
  end
end
