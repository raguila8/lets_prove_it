module Notifications
  module Sender
    class SendCommentNotifications 
      def initialize(params)
        @notification_type = params[:notification_type]
        @comment = params[:resource]
        @actor = @comment.user
        @notifiable = @comment.commented_on
        if params[:options]
          @options = params[:options]
        end

        @sent = 0
      end

      def call
        send_new_comment_notifications if @notification_type == :new_comment
        send_updated_comment_notifications if @notification_type == :updated_comment
        send_deleted_comment_notifications if @notification_type == :deleted_comment
        return { response: :success, sent: @sent }
      end

      private

      def send_deleted_comment_notifications
        action = (@comment.commented_on_type == "Proof" ? "removed your comment on a proof for " : "removed your comment on")
        n = Notification.new(actor_id: -1, recipient: @comment.user, 
                             action: action, notifiable: @comment, 
                             action_type: "deletion",
                             details: @options[:deleted_for])
        n.save(validate: false)
        @sent += 1
      end
 
      def send_new_comment_notifications
        notify_other_commenters
        notify_post_creator
        notify_post_editors
      end

      # Notify the person who wrote the post
      def notify_post_creator
        return if @actor == @notifiable.user
        action = (@comment.commented_on_type == "Proof" ? "commented on your proof for" : "commented on")
        Notification.create(recipient: @notifiable.user, actor: @actor, 
                            action: action, notifiable: @notifiable,
                            action_type: "new comment")
        @sent += 1
      end

      def notify_post_editors
        @notifiable_editors = (@notifiable.versions.map{ |v| v.user }).uniq
        (@notifiable_editors - (@commenters + [@actor, @notifiable.user])).each do |editor|
          action = (@comment.commented_on_type == "Proof" ? "commented on a proof you have edited for" : "commented on")
          Notification.create(recipient: editor, actor: @actor, 
                              action: action, notifiable: @notifiable,
                              action_type: "new comment")
          @sent += 1
        end
      end

      # Notify people who have commented on the post
      def notify_other_commenters
        @commenters = (@notifiable.comments.map{ |c| c.user }).uniq
        (@commenters - [@actor, @notifiable.user]).each do |commenter|
          action = (@comment.commented_on_type == "Proof" ? "commented on a proof you have commented on for" : "commented on")
          Notification.create(recipient: commenter, actor: @actor, 
                              action: action, notifiable: @notifiable,
                              action_type: "new comment")
          @sent += 1
        end
      end

      def send_updated_comment_notifications

      end
    end
  end
end
