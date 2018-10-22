module PostHandler
  class HandlePost
    def initialize(params)
      #@post = params[:post]
      post_type = params[:post].class.name
      #@handle = params.key?(:handle) ? params[:handle] : :all

      if post_type == "Problem"
        @handler = HandleProblem.new(post: params[:post], handle: params[:handle])
      elsif post_type == "Proof"
        @handler = HandleProof.new(post: params[:post], handle: params[:handle])
      elsif post_type == "Comment"
        @handler = HandleComment.new(post: params[:post], handle: params[:handle])
      end
    end

    def call
      @handler.call
    end
  end
end

