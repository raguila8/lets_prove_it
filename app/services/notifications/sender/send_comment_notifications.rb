module Notifications
  module Sender
    class SendCommentNotifications 
      def initialize(params)
        @notification_type = params[:notification_type]
        @comment = params[:resource]
        @actor = @comment.user
        @notifiable = @comment.commented_on
        @sent = 0
      end

      def call
        send_new_comment_notifications if @notification_type == :new_comment
        send_updated_comment_notifications if @notification_type == :updated_comment
        return { response: :success, sent: @sent }
      end

      private
 
      def send_new_comment_notifications
        notify_other_commenters
        notify_post_creator
      end

      # Notify the person who wrote the post
      def notify_post_creator
        return if @actor == @notifiable.user
        action = (@comment.commented_on_type == "Proof" ? "commented on your proof for" : "commented on")
        Notification.create(recipient: @notifiable.user, actor: @actor, 
                            action: action, notifiable: @notifiable,
                            action_type: "comment")
        @sent += 1
      end

      # Notify people who have commented on the post
      def notify_other_commenters
        ((@notifiable.comments.map{ |c| c.user }).uniq - [@actor, @notifiable.user]).each do |commenter|
          action = (@comment.commented_on_type == "Proof" ? "commented on a proof you have commented on for" : "commented on")
          Notification.create(recipient: commenter, actor: @actor, 
                              action: action, notifiable: @notifiable,
                              action_type: "comment")
          @sent += 1
        end
      end

      def send_updated_comment_notifications

      end
    end
  end
end
