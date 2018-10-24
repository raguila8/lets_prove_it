module PostHandler
  class HandleProblem
    def initialize(params)
      @problem = params[:post]
      @handle = params[:handle]
    end

    def call
      if @handle == :all
        r = check_score_and_handle
        r = check_reports_and_handle
      elsif @handle == :score
        check_score_and_handle
      elsif @handle == :reports
        check_reports_and_handle
        
      end
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
        Reputation::UpdateReputation.new(action: :spam_or_offensive_takedown,
                                         acted_on: @problem).call
      end
    end 
  end
end
