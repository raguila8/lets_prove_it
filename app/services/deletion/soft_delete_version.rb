module Deletion
  class SoftDeleteVersion < SoftDeleteBase
    def call
      soft_delete if not @version.soft_deleted?
    end

    private

    def soft_delete
      soft_delete_version
      soft_delete_activities
      notify_version_owner
    end

    def soft_delete_version
      @version.update(deleted_on: Time.now, deleted_by: @deleted_by, 
                      deleted_for: @deleted_for)
    end
 
    def soft_delete_activities
      Activity.where(acted_on: @version).each do |activity|
        activity.update(deleted_on: Time.now)
      end
    end

    def notify_version_owner
      if %w(community proof problem).include? @deleted_by.to_s
        # if version_number is 1, versioned is deleted, so versioned.user will
        # already be notified 
        if @version.version_number != 1
          Notifications::Sender::SendNotifications.new(notification_type: :deleted_version,
                           resource: @version, options: { deleted_for: @deleted_for }).call
        end
      end
    end
  end
end
