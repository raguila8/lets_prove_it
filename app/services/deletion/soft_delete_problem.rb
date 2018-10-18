module Deletion
  class SoftDeleteProblem < SoftDeleteBase
    def call
      soft_delete if not @problem.soft_deleted?
    end

    private

    def soft_delete
      soft_delete_problem
      soft_delete_versions
      soft_delete_proofs
      soft_delete_comments
    end

    def soft_delete_problem
      @problem.update(deleted_on: Time.now, deleted_by: @deleted_by, 
                      deleted_for: @deleted_for)
      soft_delete_activities
      notify_problem_creator
    end

    def soft_delete_versions
      @problem.versions.each do |version|
        deleted_for = "version was deleted as a result of the problem's deletion."
        Deletion::SoftDelete.new(resource: version, deleted_by: :problem,
                                   deleted_for: deleted_for).call
      end
    end

    def soft_delete_proofs
      @problem.proofs.each do |proof|
        deleted_for = "proof was deleted as a result of the problem's deletion."
        Deletion::SoftDelete.new(resource: proof, deleted_by: :problem,
                                   deleted_for: deleted_for).call
      end
    end

    def soft_delete_comments
      @problem.comments.each do |comment|
        deleted_for = "comment was deleted as a result of the problem's deletion."
        Deletion::SoftDelete.new(resource: comment, deleted_by: :problem,
                                   deleted_for: deleted_for).call
      end
    end

    def soft_delete_activities
      Activity.where(acted_on: @problem).each do |activity|
        activity.update(deleted_on: Time.now)
      end
    end

    def notify_problem_creator
      Notifications::Sender::SendNotifications.new(notification_type: :deleted_problem,
                           resource: @problem, actor: -1, 
                           options: { deleted_for: @deleted_for }).call
    end
  end
end
