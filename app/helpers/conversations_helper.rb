module ConversationsHelper
  def mark_all_as_read_link
    link = "<a class='mark-all-as-read-link' data-remote='true' rel='nofollow' data-method='post' href='/conversations/mark_all_as_read'>Mark all as read</a>"
    return link.html_safe
  end
end
