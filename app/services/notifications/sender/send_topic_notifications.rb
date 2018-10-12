module Notifications
  module Sender
    class SendTopicNotifications
      def initialize(params)
        @notification_type = params[:notification_type]
        @topic = params[:resource]
        @actor = params[:actor]
        @sent = 0
      end

      def call
        send_new_topic_notifications if @notification_type == :new_topic
        send_updated_topic_notifications if @notification_type == :updated_topic
        return { response: :success, sent: @sent }
      end

      private

      def send_new_topic_notifications
        notify_actor_followers_of_new_topic
      end

      def send_updated_topic_notifications
        notify_topic_followers_of_updated_topic
        notify_actor_followers_of_updated_topic
      end

      def notify_actor_followers_of_new_topic
        (@actor.followers - [@actor]).each do |follower|
          Notification.create(recipient: follower, actor: @actor,
                              action: "created", notifiable: @topic,
                              action_type: "new topic")
          @sent += 1
        end
      end

      def notify_topic_followers_of_updated_topic
        (@topic.followers - [@actor]).each do |follower|
          Notification.create(recipient: follower, actor: @actor,
                              action: "edited", notifiable: @topic,
                              action_type: "updated topic")
          @sent += 1
        end
      end

      def notify_actor_followers_of_updated_topic
        (@actor.followers - (@topic.followers + [@actor])).each do |follower|
          Notification.create(recipient: follower, actor: @actor,
                              action: "edited", notifiable: @topic,
                              action_type: "updated topic")
          @sent += 1
        end
      end

    end
  end
end
