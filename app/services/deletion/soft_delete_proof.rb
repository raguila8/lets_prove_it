module Deletion
  class SoftDeleteProof < SoftDeleteBase
    def call
      soft_delete if not @proof.soft_deleted?
    end

    private

    def soft_delete
      soft_delete_proof
    end

    def soft_delete_proof
      @proof.update(deleted_on: Time.now, deleted_by: @deleted_by,
                    deleted_for: @deleted_for)
      soft_delete_activities
      soft_delete_versions
      soft_delete_comments
      notify_proof_creator
    end

    def soft_delete_activities
      Activity.where(acted_on: @proof).each do |activity|
        activity.update(deleted_on: Time.now)
      end
    end

    def soft_delete_versions
      @proof.versions.each do |version|
        deleted_for = "version was deleted as a result of the proof's deletion."
        Deletion::SoftDelete.new(resource: version, deleted_by: :proof,
                                   deleted_for: deleted_for).call
      end 
    end

    def soft_delete_comments
      @proof.comments.each do |comment|
        deleted_for = "comment was deleted as a result of the proof's deletion."
        Deletion::SoftDelete.new(resource: comment, deleted_by: :proof,
                                   deleted_for: deleted_for).call
      end
    end

    # Notify original poster that proof has been deleted
    def notify_proof_creator
    if %w(community problem).include? @deleted_by.to_s
      Notifications::Sender::SendNotifications.new(notification_type: :deleted_proof,
                           resource: @proof, options: { deleted_for: @deleted_for }).call

      end
    end

    
  end
end
