module Notifications
  class SendNotifications
    def initialize(params)
      @notification_type = params[:notification_type]
      @actor = params[:actor]
      @acting_on = params[:acting_on]
      @acting_on_type = @acting_on.class.name
    end

    def call
      send(@notification_type)
    end

    private

      def vote_notification
        if @acting_on_type == "Problem"
          # Notify problem editors that the problem has been liked/disliked
          ((@acting_on.versions.map{ |version| version.user }).uniq - [@actor]).each do |editor|
            Notification.create(recipient: editor, actor: @actor, 
                                action: "liked", notifiable: @acting_on, 
                                action_type: "like")
            #Notification.notify_user(editor, actor, "liked", voted_on, action_type) if editor != actor
          end

        elsif @acting_on_type == "Comment"
          # Notify owner of comment
          action = (@acting_on.commented_on_type == "Proof" ? "liked your comment on a proof for" : "liked your commnent on")
          #Notification.notify_user(voted_on.user, actor, action, voted_on, action_type) if voted_on.user != actor
          Notification.create(recipient: @acting_on.user, actor: @actor, 
                              action: action, notifiable: @acting_on, 
                              action_type: "like")

        elsif @acting_on_type == "Proof"
          # Notify owner of proof
          #Notification.notify_user(voted_on.user, actor, "liked your proof for", voted_on, action_type) if voted_on.user != actor
          Notification.create(recipient: @acting_on.user, actor: @actor, 
                              action: "liked your proof for", 
                              notifiable: @acting_on, action_type: "like")
        end
      end

  end
end
