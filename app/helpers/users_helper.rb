module UsersHelper
  def user_info_list(user)
    html = "<li><strong><i class='fa fa-calendar mr-9'></i>Member Since:</strong><span>#{user.created_at.strftime('%B %d, %Y')}</span></li>"
    html += "<li><strong><i class='fa fa-user mr-9'></i>NAME:</strong><span>#{user.name}</span></li>" if !user.name.blank?
    html += "<li><strong><i class='fa fa-briefcase mr-9'></i>Occupation:</strong><span>#{user.occupation}</span></li>" if !user.occupation.blank?
    html += "<li><strong><i class='fa fa-graduation-cap mr-9'></i>Education:</strong><span>#{user.education}</span></li>" if !user.education.blank?
    html += "<li><strong><i class='fa fa-map-marker mr-9'></i>Location:</strong><span>#{user.location}</span></li>" if !user.location.blank?
    html.html_safe
  end

  def css_rep_score_position(reputation)
    rep_str_len = reputation.to_s.length
    if rep_str_len == 4
      "top: 8px; left: 6px;"
    elsif rep_str_len == 3
      "top: 8px; left: 8px;"
    elsif rep_str_len == 2
      "top: 8px; left: 12px;"
    elsif rep_str_len == 1
      "top: 10px; left: 14px;"
    end
  end

  def reputation_color(reputation)
    return "#373940" if reputation < 10
    return "#ff7361" if reputation < 200
    return "#2E8B57" if reputation < 1000
    return "#1e73be" if reputation < 5000
    return "#544f87" if reputation < 25000
    return "#DD9934" if reputation >= 25000    
  end

  def follow_button(user=nil)
    user = (user.nil? ? @user : user)
    button = "<div class='user-follow-meta' id='user-follow-#{user.id}'>"
    if !current_user.following?(user)
      button += "<a href='#{follow_user_path(user.id)}' data-remote='true' data-method='post'>"
      button += "<button class='btn btn-ghost btn-small'>Follow</button></a>"
    else
      button += "<a href='#{unfollow_user_path(user.id)}' data-remote='true' data-method='delete'>"
      button += "<button class='btn btn-small'>Following</button></a>"
    end
    button += "</div>"
    return button.html_safe
  end

  def display_name_label
    @user.name.nil? ? "Create a display name" : "Your display name"
  end

  def bio_label
    @user.bio.nil? ? "Create a short bio" : "Your bio"
  end
end
