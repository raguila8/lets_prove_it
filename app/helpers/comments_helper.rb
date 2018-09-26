module CommentsHelper
  def comment_form_id
    @action_name == "cancel_new" ? "new-comment-form" : "comment-form-#{@comment.id}"
  end

  def add_comment_button(model)
    link = ""
    if signed_in?
      if current_user.reputation >= 50 or model.user == current_user
        href="/comments/new?commented_on_type=#{model.class.name}&commented_on_id=#{model.id}"
        link = "<a href='#{href}' data-remote='true' class='comment-replay-btn mb-10 pull-left btn btn-xs'>Add Comment</a>"
      else
        link = "<button data-toggle='modal' data-target='#noPriviligeModal' class='no-comment-priv comment-replay-btn mb-10 pull-left btn btn-xs'>Add Comment</button>"
      end
    else
      link = "<button data-toggle='modal' data-target='#signinActionModal' class='comment-replay-btn mb-10 pull-left btn btn-xs'>Add Comment</button>"
    end
    link.html_safe
  end
end
