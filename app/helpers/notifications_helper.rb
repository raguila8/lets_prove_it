module NotificationsHelper
  def actor_name(actor_id)
    if actor_id == -1
      return "The community"
    else
      return User.find(actor_id).username
    end
  end

  def link_text(notification)
    if %w(Comment Problem Proof).include? notification.notifiable_type
      return "View Problem"
    elsif notification.notifiable_type == "Topic"
      return "View Topic"
    elsif notification.notifiable_type == "User"
      return "View User's Profile"
    end
  end

  def notification_link_path(notification)
    if notification.linkable?
      return notification.link
    else
      return notifications_path
    end
  end
end
