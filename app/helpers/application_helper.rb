module ApplicationHelper
  def page_title
    if controller_name == "sessions" and action_name == "new"
      "Login"
    elsif controller_name == "registrations" and action_name == "new"
      "Register"
    end
  end

  def page_subheading
    if controller_name == "sessions" and action_name == "new"
      "Login or create an account"
    elsif controller_name == "registrations" and action_name == "new"
      "Create and Account or Login"
    end
  end

  def right_heading_content
    if controller_name == "sessions" and action_name == "new"
      content = "<a href='#{new_user_registration_path}'><button class='btn-text-light btn-large'>Create an Account</button></a>"
      return content.html_safe
    elsif controller_name == "registrations" and action_name == "new"
      content = "<a href='#{new_user_session_path}'><button class='btn-text-light btn-large'>Login</button></a>"
      return content.html_safe
    end

  end
end
