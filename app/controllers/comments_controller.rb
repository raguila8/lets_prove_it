class CommentsController < ApplicationController
  before_action :set_comment, only: [:edit, :cancel_edit, :update, :destroy]

  def new
    @comment = Comment.new
    @commented_on = params[:commented_on_type].capitalize.constantize.find(params[:commented_on_id])
    @comment.assign_attributes(commented_on: @commented_on)
    @comment.user_id = current_user.id

    respond_to do |format|
      format.js {}
    end
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id

    respond_to do |format|
      if @comment.save

        if @comment.commented_on_type == "Problem"
          #Any user who comments on a problem automatically follows it
          if !current_user.bookmarked? @comment.get_problem
            current_user.bookmark @comment.get_problem
          end
        end

        Notifications::Sender::SendNotifications.new(notification_type: :new_comment,
                                                     actor: current_user,
                                                     resource: @comment).call 
        format.js {}
      else
        format.js {}
      end
    end
  end

  def edit
  end

  def cancel_edit
    respond_to do |format|
      format.js {}
    end
  end

  def cancel_new
    respond_to do |format|
      format.js {}
    end
  end

  def 

  def update
    @comment.update_attributes(comment_params)
    respond_to do |format|
      if @comment.save
        format.js {}
      else
        format.js {}
      end
    end
  end

  def destroy
    @problem = @comment.proof.problem
    @comment.destroy
    respond_to do |format|
      format.html {
        flash[:notice] = "Comment was successfully destroyed."
        redirect_to @problem
      }
      format.json { head :no_content }
    end
  end


  private

    def comment_params
      params.require(:comment).permit(:content, :commented_on_type, :commented_on_id)
    end

    def set_comment
      @comment = Comment.find(params[:id])
    end 

end
