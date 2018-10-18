module PostHandler
  class HandleProblem
    def initialize(params)
      @problem = params[:post]
      @handle = params[:handle]
    end

    def call
      check_score_and_handle and check_reports_and_handle if @handle == :all
      check_score_and_handle if @handle == :score
      check_reports_and_handle if @handle == :reports
    end

    private

    def check_score_and_handle
      if @problem.dead?
        deleted_for = "problem was over 60 days old, had a voting score of 0 or less, and had zero proofs"
        Deletion::SoftDelete.new(resource: @problem, deleted_by: :community, 
                                 deleted_for: deleted_for).call
      elsif @problem.belongs_in_review_queue?
        #@problem.send_to_review_queue
      end
    end

    def check_reports_and_handle
      if @problem.old_and_poor?
        deleted_for = "problem was over 30 days old with 3 or more reports and zero proofs"
        Deletion::SoftDelete.new(resource: @problem, deleted_by: :community, 
                                 deleted_for: deleted_for).call
      elsif @problem.spam_or_offensive?
        deleted_for = "problem was flagged as spam or offensive 6 or more times"
        Deletion::SoftDelete.new(resource: @problem, deleted_by: :community, 
                                 deleted_for: deleted_for).call
      end
    end 
  end
end
