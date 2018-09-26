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

  def notification_user_image(notification)
    if notification.actor_id < 0
      html = "<img width='60' height='60' src='#{avatar_src(notification.actor_id) }' alt='User Profile Image'>"
    else
      html = "<a href='#{ user_path(notification.actor.id) }'><img width='60' height='60' src='#{avatar_src(notification.actor_id) }' alt='User Profile Image'></a>"
    end

    return html.html_safe
  end

  def notification_actor_link(notification)
    if notification.actor_id < 0
      html = "<span class='grey-link' style='cursor: default'>#{ actor_name(notification.actor_id) } </span>"
    else
      html = "<a class='grey-link' href='#{ user_path(notification.actor.id) }'>#{ actor_name(notification.actor_id) } </a>"
    end

    return html.html_safe
  end
end
