module Deletion
  class SoftDeleteComment < SoftDeleteBase
    def call
      soft_delete if not @comment.soft_deleted?
    end

    private

    def soft_delete
      soft_delete_comment
    end

    def soft_delete_comment
      @comment.update(deleted_on: Time.now, deleted_by: @deleted_by,
                    deleted_for: @deleted_for)
      soft_delete_activities
      notify_comment_creator
    end

    def soft_delete_activities
      Activity.where(acted_on: @comment).each do |activity|
        activity.update(deleted_on: Time.now)
      end
    end
    
    def notify_comment_creator
      if %w(community proof).include? @deleted_by.to_s
        Notifications::Sender::SendNotifications.new(notification_type: :deleted_comment,
                             resource: @comment, options: { deleted_for: @deleted_for }).call
      end
    end 
  end
end
