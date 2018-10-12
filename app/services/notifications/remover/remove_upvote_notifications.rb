module Notifications
  module Remover
    class RemoveUpvoteNotifications 
      def initialize(params)
        @actor = params[:actor]
        @resource = params[:resource]
        @resource_type = @resource.class.name
        @removed = 0
      end

      def call
        remove_problem_upvote_notifications if @resource_type == "Problem"
        remove_proof_upvote_notifications if @resource_type == "Proof"
        remove_comment_upvote_notifications if @resource_type == "Comment"
        return { response: :success, removed: @removed }
      end

      private

      # Remove notifications from problem editors
      def remove_problem_upvote_notifications
        ((@resource.versions.map{ |version| version.user }).uniq - [@actor]).each do |editor|
          n = Notification.find_by(recipient: editor,
                                   actor: @actor,
                                   notifiable: @resource,
                                   action_type: "like")
          if !n.nil?
            n.destroy
            @removed += 1
          end
        end

      end

      # Remove notifications from proof editors
      def remove_proof_upvote_notifications
        ((@resource.versions.map{ |version| version.user }).uniq - [@actor]).each do |editor|
          n = Notification.find_by(recipient: @resource.user, actor: @actor, 
                    action_type: "like", 
                    notifiable: @resource) if @resource.user != @actor
          if !n.nil?
            n.destroy
            @removed += 1
          end
        end
      end

      # Remove notification from owner of comment 
      def remove_comment_upvote_notifications
        n = Notification.find_by(recipient: @resource.user, actor: @actor, 
                          action_type: "like",
                          notifiable: @resource) if @resource.user != @actor
        if !n.nil?
          n.destroy
          @removed += 1
        end
      end
    end
  end
end

