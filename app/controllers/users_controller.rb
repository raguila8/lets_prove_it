class UsersController < ApplicationController
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
end
