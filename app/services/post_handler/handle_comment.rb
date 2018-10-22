module PostHandler
  class HandleComment
    def initialize(params)
      @comment = params[:post]
      @handle = params[:handle]
    end

    def call
      if @handle == :all
        check_score_and_handle
        check_reports_and_handle
      elsif @handle == :score
        check_score_and_handle
      elsif @handle == :reports
        check_reports_and_handle
      end
    end

    private

    def check_score_and_handle
      if @comment.cached_votes_score <= -5
        deleted_for = "comment recieved a voting core of -5 or lower"
        Deletion::SoftDelete.new(resource: @comment, deleted_by: :community, 
                                 deleted_for: deleted_for).call
        #action_taken = "deletion"
      end
    end

    def check_reports_and_handle
      if @comment.reports.count >= 3
        deleted_for = "comment recieved 3 or more reports"
        Deletion::SoftDelete.new(resource: @comment, deleted_by: :community, 
                                 deleted_for: deleted_for).call
        #action_taken = "deletion"
      end
    end
  end
end
