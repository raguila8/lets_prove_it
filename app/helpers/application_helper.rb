module ApplicationHelper
  def page_title
    if controller_name == "sessions" and (action_name == "new" || action_name == "create")
      "Login"
    elsif controller_name == "registrations" and (action_name == "new" || action_name == "create")
      "Register"
    elsif controller_name == "problems"
      if action_name == "index"
        "Home"
      elsif action_name == "new"
        "Add Problem"
      elsif action_name == "show"
        @problem.title
      end
    elsif controller_name == "topics"
      if action_name == "new"
        "New Topic"
      elsif action_name == "show"
        @topic.name
      end
    end
  end

  def page_subheading
    if controller_name == "sessions" and (action_name == "new" || action_name == "create")
      "Login or create an account"
    elsif controller_name == "registrations" and (action_name == "new" || action_name == "create")
      "Create and Account or Login"
    elsif controller_name == "problems"
      if action_name == "index"
        "Filter problems by topic"
      elsif action_name == "new"
        "Make a statement to prove"
      elsif action_name == "show"
        content = "<div class='post-meta'>" + 
                    "<i class='fa fa-calendar-o'> </i>" +
                    "<span> August 01.2015</span>" +
                  "</div>"
        return content.html_safe
      end
    elsif controller_name == "topics"
      if action_name == "new"
        "Create a New Topic"
      elsif action_name == "show"
        "Description"
      end
    end
  end

  def right_heading_content
    if controller_name == "sessions" and (action_name == "new" || action_name == "create")
      content = "<a href='#{new_user_registration_path}'><button class='btn-text-light btn-large'>Create an Account</button></a>"
      return content.html_safe
    elsif controller_name == "registrations" and (action_name == "new" || action_name == "create")
      content = "<a href='#{new_user_session_path}'><button class='btn-text-light btn-large'>Login</button></a>"
      return content.html_safe
    elsif controller_name == "problems"
      if action_name == "index"

      elsif action_name == "show"
        content = "<button class='btn btn-light'>Follow</button>"
        return content.html_safe
      end
    elsif controller_name == "topics"
      if action_name == "new"
        content = "<a href='#{topics_path}'><button class='btn-text-light btn-large'>Browse Topics</button></a>"
        return content.html_safe
      elsif action_name == "show"
        content = "<button class='btn btn-light'>Follow</button>"
        return content.html_safe
      end
    end
  end
end
