module Notifications
  module Sender
    class SendUpvoteNotifications 
      def initialize(params)
        @actor = params[:actor]
        @resource = params[:resource]
        @resource_type = @resource.class.name
      end

      def call
        send_problem_upvote_notifications if @notifiable_type == "Problem"
        send_proof_upvote_notifications if @notifiable_type == "Proof"
        send_comment_upvote_notifications if @notifiable_type == "Comment"
      end

      private
 
        # Notify problem editors that the problem has been liked/disliked
        def send_problem_upvote_notifications
          ((@notifiable.versions.map{ |version| version.user }).uniq - [@actor]).each do |editor|
            Notification.create(recipient: editor, actor: @actor, 
                                action: "liked", notifiable: @notifiable, 
                                action_type: "like")
            #Notification.notify_user(editor, actor, "liked", voted_on, action_type) if editor != actor
          end
        end

        # Notify owner of proof
        def send_proof_upvote_notifications
          #Notification.notify_user(voted_on.user, actor, "liked your proof for", voted_on, action_type) if voted_on.user != actor
          Notification.create(recipient: @notifiable.user, actor: @actor,
                                action: "liked your proof for", 
                                notifiable: @notifiable, action_type: "like")
        end

        # Notify owner of comment
        def send_comment_upvote_notifications
          action = (@notifiable.commented_on_type == "Proof" ? "liked your comment on a proof for" : "liked your commnent on")
          #Notification.notify_user(voted_on.user, actor, action, voted_on, action_type) if voted_on.user != actor
          Notification.create(recipient: @notifiable.user, actor: @actor, 
                              action: action, notifiable: @notifiable, 
                              action_type: "like")
        end 
    end
  end
end
