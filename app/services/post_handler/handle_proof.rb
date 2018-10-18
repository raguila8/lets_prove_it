module PostHandler
  class HandleProof
    def initialize(params)
      @proof = params[:post]
      @handle = params[:handle]
    end

    def call
      check_score_and_handle and check_reports_and_handle if @handle == :all
      check_score_and_handle if @handle == :score
      check_reports_and_handle if @handle == :reports
    end

    private

    def check_score_and_handle
      if @proof.cached_votes_score <= -4
        #@proof.send_to_review_queue
      end
    end

    def check_reports_and_handle
      if @proof.spam_or_offensive?
        deleted_for = "comment was flagged as spam or offensive 6 or more times"
        Deletion::SoftDelete.new(resource: @proof, deleted_by: :community, 
                                 deleted_for: deleted_for).call
        #action_taken = "deletion"
      end
    end

  end
end