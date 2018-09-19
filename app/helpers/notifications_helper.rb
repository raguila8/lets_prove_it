module NotificationsHelper
  def actor_name(actor_id)
    if actor_id == -1
      return "The community"
    else
      return User.find(actor_id).username
    end
  end
end
