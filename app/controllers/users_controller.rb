class UsersController < ApplicationController
  before_action :authenticate_user!, only:  [:follow, :unfollow, :vote]
  before_action :set_user, only: [:follow, :unfollow, :proofs,
                                     :problem_edits, :problems_following,
                                     :topics_following, :topic_edits, :show, 
                                     :followers, :following]

  def follow
    current_user.follow @user 
  end

  def unfollow
    current_user.unfollow @user
  end

  def followers
    @users = @user.followers
  end

  def following
    @users = @user.following
  end

  def proofs
    @proofs = @user.proofs.order(:created_at)
  end

  def problem_edits
    @versions = @user.versions.where(topic_id: nil).order(created_at: :desc)
  end

  def problems_following
    @problems = @user.problems_following.order(created_at: :desc)
  end

  def topics_following
    @topics = @user.topics_following.order(created_at: :desc)
  end

  def topic_edits
    @versions = @user.versions.where(problem_id: nil).order(created_at: :desc)
  end

  def show
  end

  def vote
    @vote_type = params[:vote_type]
    @votable_type = params[:votable_type]
    if @votable_type == "problem"
      @problem = Problem.find(params[:id])
      if @vote_type == "like"
        if !current_user.liked? @problem
          @problem.liked_by current_user 
          @voted = true
        end
      else
        if !current_user.voted_down_on? @problem
          @problem.downvote_from current_user 
          @voted = true
        end
      end
      if @voted
        # Notify problem editors that the problem has been liked/disliked
        ((@problem.versions.map{ |version| version.user }).uniq - [current_user]).each do |editor|
          Notification.notify_user(editor, current_user, @vote_type == "like" ? "liked": "disliked", @problem) if editor != current_user
        end
      end

    elsif @votable_type == "comment"
      @comment = Comment.find(params[:id])
      if @vote_type == "like"
        if !current_user.liked? @comment
          @comment.liked_by current_user
          @voted = true
        end
      else
        if !current_user.voted_down_on? @comment
          @comment.downvote_from current_user
          @voted = true
        end
      end
      if @voted
        # Notify owner of comment 
        Notification.notify_user(@comment.user, current_user, (@vote_type == "like" ? "liked": "disliked") + " your comment on a proof for", @comment.proof.problem) if @comment.user != current_user
      end
    elsif @votable_type == "proof"
      @proof = Proof.find(params[:id])
      if @vote_type == "like"
        if !current_user.liked? @proof
          @proof.liked_by current_user
          @voted = true
        end
      else
        if !current_user.voted_down_on? @proof
          @proof.downvote_from current_user
          @voted = true
        end
      end
      if @voted
        # Notify owner of proof
        Notification.notify_user(@proof.user, current_user, (@vote_type == "like" ? "liked": "disliked") + " your proof for", @proof.problem) if @proof.user != current_user
      end
    end

    respond_to do |format|
      format.js
      format.json
      format.html
    end
  end

  def index
    respond_to do |format|
      format.json {
        data = User.where("username LIKE :name", { name: "#{params[:term]}%" }).map {|t| t.username}
        render json: { suggestions: data, success: true }
      }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

end
