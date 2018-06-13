module ApplicationHelper
  def page_title
    if controller_name == "sessions" and (action_name == "new" || action_name == "create")
      "Login"
    elsif controller_name == "registrations" and (action_name == "new" || action_name == "create")
      "Register"
    elsif controller_name == "problems" and action_name == "index"
      "Home"
    end
  end

  def page_subheading
    if controller_name == "sessions" and (action_name == "new" || action_name == "create")
      "Login or create an account"
    elsif controller_name == "registrations" and (action_name == "new" || action_name == "create")
      "Create and Account or Login"
    elsif controller_name == "problems" and action_name == "index"
      "Filter problems by topic"
    end
  end

  def right_heading_content
    if controller_name == "sessions" and (action_name == "new" || action_name == "create")
      content = "<a href='#{new_user_registration_path}'><button class='btn-text-light btn-large'>Create an Account</button></a>"
      return content.html_safe
    elsif controller_name == "registrations" and (action_name == "new" || action_name == "create")
      content = "<a href='#{new_user_session_path}'><button class='btn-text-light btn-large'>Login</button></a>"
      return content.html_safe
    elsif controller_name == "problems" and action_name == "index"
      
    end
  end
end
