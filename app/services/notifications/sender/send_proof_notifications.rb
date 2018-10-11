module Notifications
  module Sender
    class SendProofNotifications 
      def initialize(params)
        @notification_type = params[:notification_type]
        @proof = params[:resource]
        @actor = params[:actor]
        @sent = 0
      end

      def call
        send_new_proof_notifications if @notification_type == :new_proof
        send_updated_proof_notifications if @notification_type == :updated_proof
        return { response: :success, sent: @sent }
      end

      private

        # Send notifications to users who follow a problem when a new proof is
        # created
        def send_new_proof_notifications
          notify_problem_followers_of_new_proof
          notify_followers_of_new_proof
        end

        def notify_problem_followers_of_new_proof
          action = "posted a new proof for"
          (@proof.problem.followers - [@proof.user]).each do |follower|
            Notification.create(recipient: follower, actor: @proof.user,
                                action: action, notifiable: @proof, 
                                action_type: "new proof")
            @sent += 1
          end

        end

        def notify_followers_of_new_proof
          action = "posted a new proof for"
          (@actor.followers - (@proof.problem.followers + [@actor])).each do |follower|
            Notification.create(recipient: follower, actor: @proof.user,
                                action: action, notifiable: @proof,
                                action_type: "new proof")
            @sent += 1
          end
        end

        def send_updated_proof_notifications
          notify_problem_creator_of_edit
          notify_editors_of_edit
          notify_commenters_of_edit
          notify_problem_followers_of_edit
          notify_followers_of_edit
        end

        # Notify creator of proof if editor is not creator
        def notify_problem_creator_of_edit
          if @proof.user != @actor
            action = "edited your proof for"
            Notification.create(recipient: @proof.user, actor: @actor,
                                action: action, notifiable: @proof,
                                action_type: "proof edit")
            @sent += 1
          end
        end

        # Send notifications to users who have previously edited the proof
        def notify_editors_of_edit
          action = "edited a proof you have previously edited for"
          @editors = ((@proof.versions.map { |v| v.user }).uniq)
          (@editors - [@actor, @proof.user].uniq).each do |e|
            Notification.create(recipient: e, actor: @actor,
                                action: action, notifiable: @proof,
                                action_type: "proof edit")
            @sent += 1
          end
        end

        # Send notifications to users who have commented on the proof
        def notify_commenters_of_edit
          action = "edited a proof that you have commented on for"
          @commenters = (@proof.comments.map { |c| c.user }).uniq 
          (@commenters - (@editors + [@actor, @proof.user].uniq)).each do |commenter|
            Notification.create(recipient: commenter, actor: @actor,
                                action: action, notifiable: @proof, 
                                action_type: "proof edit")
            @sent += 1
          end
        end
      
        # Send notifications to users who follow the proof's problem 
        def notify_problem_followers_of_edit
          action = "edited a proof for"
          @exclusions = (@commenters + @editors + [@actor, @proof.user].uniq)
          (@proof.problem.followers - @exclusions).each do |follower|
            Notification.create(recipient: follower, actor: @actor,
                                action: action, notifiable: @proof, 
                                action_type: "proof edit")
            @sent += 1
          end
        end

        def notify_followers_of_edit
          action = "edited a proof for"
          (@actor.followers - (@proof.problem.followers + @exclusions)).each do |follower|
            Notification.create(recipient: follower, actor: @actor,
                                action: action, notifiable: @proof,
                                action_type: "proof edit")
            @sent += 1
          end
        end

    end
  end
end
