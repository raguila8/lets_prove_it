module Deletion
  class SoftDelete
    def initialize(params)
      resource_type = params[:resource].class.name

      if resource_type == "Problem"
        @soft_deleter = SoftDeleteProblem.new(params)
      elsif resource_type == "Proof"
        @soft_deleter = SoftDeleteProof.new(params)
      elsif resource_type == "Comment"
        @soft_deleter = SoftDeleteComment.new(params)
      elsif resource_type == "Version"
        @soft_deleter = SoftDeleteVersion.new(params)
      end
    end

    def call
      @soft_deleter.call
    end
  end
end
