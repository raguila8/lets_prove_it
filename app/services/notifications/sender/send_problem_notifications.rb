module Notifications
  module Sender
    class SendProblemNotifications 
      def initialize(params)
        @notification_type = params[:notification_type]
        @problem = params[:resource]
        @actor = params[:actor]
        @sent = 0
        if params[:options]
          @options = params[:options]
        end
      end

      def call
        send_new_problem_notifications if @notification_type == :new_problem
        send_updated_problem_notifications if @notification_type == :updated_problem
        send_deleted_problem_notifications if @notification_type == :deleted_problem
        return { response: :success, sent: @sent }
      end

      private

        def send_deleted_problem_notifications
          action = "removed"
          n = Notification.new(actor_id: -1, recipient: @problem.user, 
                               action: action, notifiable: @problem, 
                               action_type: "deletion", 
                               details: @options[:deleted_for])
          n.save(validate: false)
          @sent += 1 
        end

        def send_updated_problem_notifications
          notify_problem_followers_of_edit
          notify_followers_of_edit
        end

        def send_new_problem_notifications
          notify_followers_of_new_problem
        end

        def notify_problem_followers_of_edit
          action = "edited"

          (@problem.followers  - [@actor]).each do |follower|
            Notification.create(recipient: follower, actor: @actor, 
                                action: action, notifiable: @problem, 
                                action_type: "problem edit")
            @sent += 1
          end
        end
  
        def notify_followers_of_edit
          action = "edited"
          (@actor.followers - (@problem.followers + [@actor])).each do |follower|
            Notification.create(recipient: follower, actor: @actor,
                                action: action, notifiable: @problem,
                                action_type: "problem edit")
            @sent += 1
          end
        end

        def notify_followers_of_new_problem
          action = "created"
          (@actor.followers - (@problem.followers + [@actor])).each do |follower|
            Notification.create(recipient: follower, actor: @actor,
                                action: action, notifiable: @problem,
                                action_type: "new problem")
            @sent += 1
          end
        end

    end
  end
end
