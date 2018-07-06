module ApplicationHelper
  def page_title
    if controller_name == "sessions" and (action_name == "new" || action_name == "create")
      "Login"
    elsif controller_name == "registrations" and (action_name == "new" || action_name == "create")
      "Register"
    elsif controller_name == "problems"
      if action_name == "index"
        "Home"
      elsif action_name == "new" || action_name == "create"
        "Add Problem"
      elsif action_name == "show"
        @problem.title
      elsif action_name == "logs"
        @problem.title
      elsif action_name == "edit" || action_name == "update"
        @problem.title
      end
    elsif controller_name == "topics"
      if action_name == "new" || action_name == "create"
        "New Topic"
      elsif action_name == "show"
        @topic.name
      elsif action_name == "logs"
        @topic.name
      elsif action_name == "edit" || action_name == "update"
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
      elsif action_name == "new" || action_name == "create"
        "Make a statement to prove"
      elsif action_name == "show"
        content = "<div class='post-meta'>" + 
                    "<i class='fa fa-calendar-o'> </i>" +
                    "<span> #{@problem.created_at.strftime('%B %d, %Y')} </span>" +
                  "</div>"
        return content.html_safe
      elsif action_name == "logs"
        "Problem Edits"
      elsif action_name == "edit" || action_name == "update"
        "Edit Problem"
      end
    elsif controller_name == "topics"
      if action_name == "new" || action_name == "create"
        "Create a New Topic"
      elsif action_name == "show"
        "Description"
      elsif action_name == "logs"
        "Topic Edits"
      elsif action_name == "edit" || action_name == "update"
        "Edit Topic"
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
        content = "<a href='#{problem_path(Problem.random_problem)}'><button class='btn-text-light btn-large'>I'm Feeling Lucky</button></a>"
        return content.html_safe
      elsif action_name == "show"
        content = ""
        if signed_in?
          if !current_user.following?(@problem)
            content = "<a href='#{problem_follow_path(@problem.id)}' data-remote='true' data-method='post'>"
            content += "<button class='btn btn-light mr-20'>Follow</button></a>"
          else
            content = "<a href='#{problem_unfollow_path(@problem.id)}' data-remote='true' data-method='delete'>"
            content += "<button class='btn btn-light mr-20'>Following</button></a>"
          end
          return content.html_safe
        end
      elsif action_name == "logs"
        content = "<a href='#{edit_problem_path(@problem.id)}'><button class='btn-text-light btn-large'>Edit Problem</button></a>"
        return content.html_safe
      end
    elsif controller_name == "topics"
      if action_name == "new" || action_name == "create"
        content = "<a href='#{topics_path}'><button class='btn-text-light btn-large'>Browse Topics</button></a>"
        return content.html_safe
      elsif action_name == "show"
        content = ""
        if signed_in?
          if !current_user.following?(@topic)
            content = "<a href='#{topic_follow_path(@topic.id)}' data-remote='true' data-method='post'>"
            content += "<button class='btn btn-light mr-20'>Follow</button></a>"
          else
            content = "<a href='#{topic_unfollow_path(@topic.id)}' data-remote='true' data-method='delete'>"
            content += "<button class='btn btn-light mr-20'>Following</button></a>"
          end
          return content.html_safe
        end
        return content.html_safe
      elsif action_name == "logs"
        content = "<a href='#{edit_topic_path(@topic.id)}'><button class='btn-text-light btn-large'>Edit Topic</button></a>"
        return content.html_safe
      elsif action_name == "edit" || action_name == "update"
        
      end
    end
  end
end
