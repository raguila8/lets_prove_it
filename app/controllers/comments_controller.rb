class CommentsController < ApplicationController
  before_action :set_comment, only: [:edit, :cancel_edit, :update, :destroy]

  def new
    @comment = Comment.new
    @proof = Proof.find(params[:proof_id])
    @comment.proof_id = @proof.id
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
        # Notify people who have commented on the proof
        ((@comment.proof.comments.map{ |comment| comment.user }).uniq - [current_user, @comment.proof.user]).each do |commenter|
          Notification.notify_user(commenter, current_user, "commented on a proof you have commented on for", @comment.proof.problem)
        end

        # Notify the person who wrote the proof
        Notification.notify_user(@comment.proof.user, current_user, "commented on your proof for", @comment.proof.problem) if @comment.proof.user != current_user
 
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
      params.require(:comment).permit(:content, :proof_id)
    end

    def set_comment
      @comment = Comment.find(params[:id])
    end 

end
