module Notifications
  module Sender
    class SendNotifications

      def initialize(params)
        notification_type = params[:notification_type]

        if notification_type == :upvote
          @notifications_sender = SendUpvoteNotifications.new(params)
        elsif [:new_comment, :updated_comment].include? notification_type
          @notifications_sender = SendCommentNotifications.new(params)
        elsif [:new_proof, :updated_proof].include? notification_type
          @notifications_sender = SendProofNotifications.new(params)
        elsif [:new_problem, :updated_problem].include? notification_type
          @notifications_sender = SendProblemNotifications.new(params)
        elsif [:new_topic, :updated_topic].include? notification_type
          @notifications_sender = SendTopicNotifications.new(params)
        end
      end

      def call
        @notifications_sender.call
      end
    end
  end
end
