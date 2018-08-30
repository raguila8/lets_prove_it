class CommentsController < ApplicationController
  before_action :set_comment, only: [:edit, :cancel_edit, :update, :destroy]

  def new
    @comment = Comment.new
    @commented_on = params[:commented_on_type].capitalize.constantize.find(params[:commented_on_id])
    @comment.update_attributes(commented_on: @commented_on)
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
        notifiable = (@comment.commented_on_type == "Proof" ? @comment.commented_on.problem : @comment.commented_on)

        # Notify people who have commented on the post
        ((@comment.commented_on.comments.map{ |comment| comment.user }).uniq - [current_user, @comment.commented_on.user]).each do |commenter|
          action = (@comment.commented_on_type == "Proof" ? "commented on a proof you have commented on for" : "commented on")
          Notification.notify_user(commenter, current_user, action, notifiable)
        end

        # Notify the person who wrote the post
        action = (@comment.commented_on_type == "Proof" ? "commented on your proof for" : "commented on")

        Notification.notify_user(@comment.proof.user, current_user, action, notifiable) if @comment.commented_on.user != current_user
 
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
