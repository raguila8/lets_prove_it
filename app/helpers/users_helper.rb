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
end
