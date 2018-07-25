module UsersHelper
  def user_info_list(user)
    html = "<li><strong><i class='fa fa-calendar mr-9'></i>Member Since:</strong><span>#{user.created_at.strftime('%B %d, %Y')}</span></li>"
    html += "<li><strong><i class='fa fa-user mr-9'></i>NAME:</strong><span>#{user.name}</span></li>" if !user.name.blank?
    html += "<li><strong><i class='fa fa-briefcase mr-9'></i>Occupation:</strong><span>#{user.occupation}</span></li>" if !user.occupation.blank?
    html += "<li><strong><i class='fa fa-graduation-cap mr-9'></i>Education:</strong><span>#{user.education}</span></li>" if !user.education.blank?
    html += "<li><strong><i class='fa fa-map-marker mr-9'></i>Location:</strong><span>#{user.location}</span></li>" if !user.location.blank?
    html.html_safe
  end
end
