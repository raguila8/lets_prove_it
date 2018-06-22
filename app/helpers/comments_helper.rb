module CommentsHelper
  def comment_form_id
    @action_name == "cancel_new" ? "new-comment-form" : "comment-form-#{@comment.id}"
  end
end
