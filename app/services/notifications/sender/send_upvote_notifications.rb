module Notifications
  module Sender
    class SendUpvoteNotifications 
      def initialize(params)
        @actor = params[:actor]
        @resource = params[:resource]
        @resource_type = @resource.class.name
        @sent = 0
      end

      def call
        send_problem_upvote_notifications if @resource_type == "Problem"
        send_proof_upvote_notifications if @resource_type == "Proof"
        send_comment_upvote_notifications if @resource_type == "Comment"
        return { response: :success, sent: @sent }
      end

      private
 
        # Notify problem editors that the problem has been liked
        def send_problem_upvote_notifications
          ((@resource.versions.map{ |version| version.user }).uniq - [@actor]).each do |editor|
            Notification.create(recipient: editor, actor: @actor, 
                                action: "liked", notifiable: @resource, 
                                action_type: "like")
            @sent += 1
          end
        end

        # Notify previous editors
        def send_proof_upvote_notifications
          ((@resource.versions.map{ |version| version.user }).uniq - [@actor]).each do |editor|
            Notification.create(recipient: @resource.user, actor: @actor,
                                action: "liked your proof for",
                                notifiable: @resource, action_type: "like")
            @sent += 1
          end
        end

        # Notify owner of comment
        def send_comment_upvote_notifications
          action = (@resource.commented_on_type == "Proof" ? "liked your comment on a proof for" : "liked your commnent on")
          Notification.create(recipient: @resource.user, actor: @actor, 
                              action: action, notifiable: @resource, 
                              action_type: "like") if @actor != @resource.user
          @sent += 1
        end 
    end
  end
end
