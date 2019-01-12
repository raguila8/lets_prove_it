module CommentsHelper
  def comment_form_id
    @action_name == "cancel_new" ? "new-comment-form" : "comment-form-#{@comment.id}"
  end

  def add_comment_button(model)
    link = ""
    if signed_in?
      if current_user.reputation >= 50 or model.user == current_user
        href="/comments/new?commented_on_type=#{model.class.name}&commented_on_id=#{model.id}"
        link = "<a href='#{href}' data-remote='true' class='comment-replay-btn mb-10 pull-left btn btn-xs'>Reply</a>"
        link = "<a class='greyLink headerFont replyCommentLink' data-comment-id='#{model.id}'><i class='mr-5 fa fa-comment-o'></i>Reply</a>"
      else
        link = "<button data-toggle='modal' data-target='#noPriviligeModal' class='no-comment-priv comment-replay-btn mb-10 pull-left btn btn-xs'>Add Comment</button>"
        link = "<button data-toggle='modal' data-target='#noPriviligeModal' class='greyLink headerFont no-comment-priv'><i class='mr-5 fa fa-comment-o'></i>Reply</button>"

      end
    else
      link = "<button data-toggle='modal' data-target='#signinActionModal' class='comment-replay-btn mb-10 pull-left btn btn-xs'>Add Comment</button>"
      link = "<button data-toggle='modal' data-target='#signinActionModal' class='greyLink headerFont no-comment-priv'><i class='mr-5 fa fa-comment-o'></i>Reply</button>"
    end
    link.html_safe
  end

  def comments_dropdown_span(resource)
    if resource.comments.active.count > 0
      return "<span>Comments (#{resource.comments.count})</span>".html_safe
    else
      return "<span>Leave a comment</span>".html_safe
    end
  end
end
