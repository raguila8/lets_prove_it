module Notifications
  class RemoveNotifications
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
          # Remove notifications from problem editors
          ((@acting_on.versions.map{ |version| version.user }).uniq - [@actor]).each do |editor|
            n = Notification.find_by(recipient: editor,
                                 actor: @actor,
                                 notifiable: @acting_on,
                                 action_type: "like") if editor != @actor
            n.destroy if !n.nil?
        end

        elsif @acting_on_type == "Comment"
          # Remove notification from owner of comment 
          n = Notification.find_by(recipient: @acting_on.user, actor: @actor, 
                    action_type: "like",
                    notifiable: @acting_on) if @acting_on.user != @actor
          n.destroy if !n.nil?

        elsif @acting_on_type == "Proof"
          # Remove notifications from  owner of proof
          n = Notification.find_by(recipient: @acting_on.user, actor: @actor, 
                    action_type: "like", 
                    notifiable: @acting_on) if @acting_on.user != @actor
          n.destroy if !n.nil?

        end
      end

  end
end
