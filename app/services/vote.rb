class Vote
  def initialize(params)
    @user = params[:user]
    @post = params[:post]
    @vote_type = params[:vote_type]

    @post_type = @post.class.name
    @action_taken = action_taken
  end

  def call
    if @action_taken == :none
      return OpenStruct.new(:response => :error, :vote_type => @vote_type, 
                           :action_taken => :none)
    end

    send(@action_taken)
    
    Reputation::UpdateReputation.new(action: @action_taken, actor: @user, acted_on: @post).call
    PostHandler::HandlePost.new(post: @post, handle: :all).call
=begin
    if @post_type == "Comment"
      if @post.cached_votes_score <= -5
        @post.take_down("community", "#{@post_type.downcase} recieved a voting score of -5 or lower")
        #action_taken = "deletion"
      elsif @post.reports.count >= 3 and @post.cached_votes_score <= 0
        @post.take_down("community", "#{@post_type.downcase} recieved 3 or more reports and had a voting score of 0 or less")
        #action_taken = "deletion"
      end
    end
=end

    return OpenStruct.new(:response => :success, :vote_type => @vote_type, 
                           :action_taken => @action_taken)
  end

  private

    def action_taken
      return :none if @user.reputation < 10 or @user == @post.user
      if @vote_type == "like"
        return :undislike if @user.voted_down_on? @post
        return :like if !@user.liked? @post
      elsif @vote_type == "dislike"
        return :unlike if @user.liked? @post
        if !@user.voted_down_on? @post
          return :none if @user.reputation < 200
          return :dislike
        end
      end

      return :none
    end

    def like
      @post.liked_by @user
      Notifications::Sender::SendNotifications.new(notification_type: :upvote, 
                             actor: @user, resource: @post).call
    end

    def dislike
      @post.downvote_from @user
    end

    def unlike
      @post.unliked_by @user
      Notifications::Remover::RemoveNotifications.new(notification_type: :upvote, 
                                            actor: @user, resource: @post).call
    end

    def undislike
      @post.undisliked_by @user
    end
end
