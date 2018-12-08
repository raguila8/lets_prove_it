module ApplicationHelper

  def flash_class
    return 'notice' if flash[:notice]
    return 'alert' if flash[:alert]
    return 'error' if flash[:error]
    return 'success' if flash[:success]
  end

  def flash_message
    return flash[:notice] if flash[:notice]
    return flash[:alert] if flash[:alert]
    return flash[:error] if flash[:error]
    return flash[:success] if flash[:success]
  end

  def navbar_position
    if controller_name == "static_pages"
      if action_name == "landing"
        "navbar-trans navbar-fixed-top"
      end
    else
      "navbar-static-top"
    end
  end

  def header
    if "static_pages" == controller_name
      if %w(mathjax_cheatsheet contact).include? action_name
        render partial: "layouts/header2"
      end
    elsif ("problems" == controller_name and (action_name == "index" or action_name == "feed")) or (controller_name == "topics" and action_name == "index") or current_page?(root_path)
      return
    elsif %w(users topics problems).include? controller_name and action_name == "index"
      render partial: "layouts/header2"
    else
      render partial: "layouts/header1"
    end
  end

  def page_title
    if controller_name == "sessions" and (action_name == "new" || action_name == "create")
      "Login"
    elsif controller_name == "registrations" and (action_name == "new" || action_name == "create")
      "Register"
    elsif controller_name == "problems"
      if action_name == "index"
        "Problems"
      elsif action_name == "feed"
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
      elsif action_name == "index"
        "Topics"
      end
    elsif controller_name == "conversations"
      if action_name == "show"
        "Conversations"
      end
    elsif controller_name == "notifications"
      if action_name == "index"
        "Notifications"
      end
    elsif controller_name == "users"
      if action_name == "show"
        @user.username
      elsif action_name == "index"
        "Users"
      end
    elsif controller_name == "static_pages"
      if action_name == "contact"
        "Contact"
      end
    elsif controller_name == "help_center"
      if action_name == "priviliges"
        "Priviliges"
      elsif action_name == "mathjax_cheatsheet"
        "Mathjax / LaTeX Support"
      elsif action_name == "deleting_posts"
        "How Can a Post be Deleted?"
      elsif action_name == "badges"
        "What Are Badges?"
      elsif action_name == "creating_topics"
        "How to Create New Topics"
      elsif action_name == "editing_posts"
        "How to Edit Posts"
      elsif action_name == "expected_behavior"
        "Expected Behavior"
      elsif action_name == "good_problems"
        "How do I Write a Good Problem?"
      elsif action_name == "on_problem_feed"
        "How do I Find Problems that I am Interested in?"
      elsif action_name == "on_topics"
        "What Are Topics and How do I Use Them?"
      elsif action_name == "reputation"
        "Reputation"
      end
    end
  end

  def page_subheading
    if controller_name == "sessions" and (action_name == "new" || action_name == "create")
      "Login or create an account"
    elsif controller_name == "registrations" and (action_name == "new" || action_name == "create")
      "Create and Account or Login"
    elsif controller_name == "problems"
      if action_name == "feed"
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
      elsif action_name == "index"
        content = "<div class='col-sm-offset-3 col-sm-6' id='search-header'><div class='form-group'>" + 
                    "<input type='search' placeholder='Filter by title' class='form-control'>" +
                    "<button class='inside-input-btn'><i class='fa fa-search'></i></button>" +
                  "</div></div>"
        return content.html_safe
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
      elsif action_name == "index"
        content = "<div class='col-sm-offset-3 col-sm-6' id='search-header'><div class='form-group'>" + 
                    "<input type='search' placeholder='Filter by name' class='form-control'>" +
                    "<button class='inside-input-btn'><i class='fa fa-search'></i></button>" +
                  "</div></div>"
        return content.html_safe

      end
    elsif controller_name == "conversations"
      if action_name == "show"
        "Message Users Privately"
      end
    elsif controller_name == "notifications"
      if action_name == "index"
        "Manage all your notifications"
      end
    elsif controller_name == "users"
      if action_name == "show"
        @user.name
      elsif action_name == "index"
        content = "<div class='col-sm-offset-3 col-sm-6' id='search-header'><div class='form-group'>" + 
                    "<input type='search' placeholder='Filter by username' class='form-control'>" +
                    "<button class='inside-input-btn'><i class='fa fa-search'></i></button>" +
                  "</div></div>"
        return content.html_safe
      end
    elsif controller_name == "static_pages"
      if action_name == "contact"
        "Love to Hear From You"
      end
    elsif controller_name == "help_center"
      if action_name == "priviliges"
        "Earn priviliges with reputation"
      elsif action_name == "mathjax_cheatsheet"
        "Render Math with Ease!"
      elsif action_name == "deleting_posts"
   
      end
    end
  end

  def right_heading_content
    if controller_name == "sessions" and (action_name == "new" || action_name == "create")
      content = "<a href='#{new_user_registration_path}'><button class='btn-text-light'>Create an Account</button></a>"
      return content.html_safe
    elsif controller_name == "registrations" and (action_name == "new" || action_name == "create")
      content = "<a href='#{new_user_session_path}'><button class='btn-text-light'>Login</button></a>"
      return content.html_safe
    elsif controller_name == "problems"
      if action_name == "index"
        content = "<a href='#{problem_path(Problem.random_problem)}'><button class='btn-text-light'>I'm Feeling Lucky</button></a>"
        return content.html_safe
      elsif action_name == "show"
        content = ""
        if signed_in?
          content += "<div id='problem-follow-#{@problem.id}' data-class='btn btn-light mr-20'>"
          if !current_user.following?(@problem)
            content += "<a href='#{problem_follow_path(@problem.id)}' data-remote='true' data-method='post'>"
            content += "<button class='btn btn-light mr-20'>Follow</button></a>"
          else
            content += "<a href='#{problem_unfollow_path(@problem.id)}' data-remote='true' data-method='delete'>"
            content += "<button class='btn btn-light mr-20'>Following</button></a></div>"
          end
          return content.html_safe
        end
      elsif action_name == "logs"
        content = "<a href='#{edit_problem_path(@problem.id)}'><button class='btn-text-light'>Edit Problem</button></a>"
        return content.html_safe
      end
    elsif controller_name == "topics"
      if action_name == "new" || action_name == "create"
        content = "<a href='#{topics_path}'><button class='btn-text-light'>Browse Topics</button></a>"
        return content.html_safe
      elsif action_name == "show"
        content = ""
        if signed_in?
          content += "<div id='topic-follow-#{@topic.id}' data-class='btn btn-light mr-20'>"
          if !current_user.following?(@topic)
            content += "<a href='#{topic_follow_path(@topic.id)}' data-remote='true' data-method='post'>"
            content += "<button class='btn btn-light mr-20'>Follow</button></a>"
          else
            content += "<a href='#{topic_unfollow_path(@topic.id)}' data-remote='true' data-method='delete'>"
            content += "<button class='btn btn-light mr-20'>Following</button></a></div>"
          end
          return content.html_safe
        end
        return content.html_safe
      elsif action_name == "logs"
        content = "<a href='#{edit_topic_path(@topic.id)}'><button class='btn-text-light'>Edit Topic</button></a>"
        return content.html_safe
      elsif action_name == "edit" || action_name == "update"
        
      end
    elsif controller_name == "conversations"
      if action_name == "show"
        content = "<a href='#' id='new-conversation-toggle' data-toggle='modal', data-target='#newConversationModal'><button class='btn btn-light'><span class='glyphicon glyphicon-pencil'></span> New Conversation</button></a>"
        return content.html_safe
      end
    elsif controller_name == "notifications"
      if action_name == "index"
        content = "<a href='#{problem_path(Problem.random_problem)}'><button class='btn-text-light'>I'm Feeling Lucky</button></a>".html_safe
      end
    elsif controller_name == "users"
      if action_name == "show"
        if signed_in? and @user != current_user
          content = "<div id='user-follow-#{@user.id}' data-class='btn btn-light mr-20'>"
          if !current_user.following?(@user)
            content += "<a href='#{follow_user_path(@user.id)}' data-remote='true' data-method='post'>"
            content += "<button class='btn btn-light mr-20'>Follow</button></a>"
          else
            content += "<a href='#{unfollow_user_path(@user.id)}' data-remote='true' data-method='delete'>"
            content += "<button class='btn btn-light mr-20'>Following</button></a></div>"
          end
          return content.html_safe
        end
      end
    elsif controller_name == "help_center"
      if action_name != "help"
        content = "<a href='#{help_path}'><button class='btn-ghost-light btn-small'>Help Center</button></a>"
        return content.html_safe
      end
    end
  end

  def error_message (msg)
    html = "<div id='error_explanation'><ul><li>#{msg}</li></ul></div>"
    return html.html_safe
  end

  def user_avatar_src(user)
    if user.avatar.thumb.url
      user.avatar.thumb.url
    else
      "/assets/avatar.png"
    end
  end

  def other_user(conversation)
    (conversation.participants - [current_user])[0]
  end

  def sent_icon(conversation)
    if conversation.last_sender == current_user
      icon = "<span class='ml-5 glyphicon glyphicon-send'></span>"
      return icon.html_safe
    end
  end

  def notifications_badge
    unread_notifications_count = current_user.unread_notifications.count
    if unread_notifications_count > 0
      badge = "<span class='badge notification-badge'>#{unread_notifications_count}</span>"
      return badge.html_safe
    end
  end

  def messages_badge
    unread_messages = current_user.mailbox.conversations.unread(current_user).count
    if unread_messages > 0
      badge = "<span class='badge notification-badge'>#{unread_messages}</span>"
      return badge.html_safe
    end
  end

  def mark_as_read_icon(conversation="mark")
    if conversation == "mark" || conversation.is_read?(current_user)
      icon = "<i class='mark-as-read fa fa-circle float-right mr-20' title='Mark as unread'></i>"
      return icon.html_safe
    else
      icon = "<i class='mark-as-read fa fa-circle-o float-right mr-20' title='Mark as read'></i>"
      return icon.html_safe
    end
  end

  def no_results_content(model)
    content = "<div class='no-results-container'><img src='/assets/no_#{model}_icon.png'><h3 class='font-weight-600'>No #{model} to show.</h3></div>"
    content.html_safe
  end

  def upvote_span(model)
    model_str = model.class.name.downcase
    "<span id='#{model_str}-upvote-#{model.id}' class='glyphicon glyphicon-triangle-top #{"upvoted" if signed_in? and current_user.liked? model}'></span>".html_safe
  end

  def vote_count_span(model)
    model_str = model.class.name.downcase
    vote = ""
    vote = "upvoted" if signed_in? and current_user.liked? model
    vote = "downvoted" if signed_in? and current_user.voted_down_on? model
    "<span class='#{vote}' id='#{model_str}-vote-count-#{model.id}' style='text-align: center; margin-left: -2px;'>#{model.cached_votes_score} </span>".html_safe
  end

  def downvote_span(model)
    model_str = model.class.name.downcase
    "<span id='#{model_str}-downvote-#{model.id}' class='glyphicon glyphicon-triangle-bottom #{"downvoted" if signed_in? and current_user.voted_down_on? model}'></span>".html_safe
  end

  def vote_actions(model)
    render partial: "/shared/vote_actions", locals: { model: model }
  end

  def follow_link(model, options={})
    model_str = model.class.name.downcase.pluralize
    content = ""
    if !current_user.following?(model)
      content = "<a class='#{'mt-0' if model_str == "users"}' href='/#{model_str}/#{model.id}/follow' data-remote='true' data-method='post'>"
      content += "<button class='#{options[:class]}'>Follow</button></a>"
    else
      content += "<a class='#{'mt-0' if model_str == "users"}' href='/#{model_str}/#{model.id}/unfollow' data-remote='true' data-method='delete'>"
      content += "<button class='#{options[:class]}'>Following</button></a>"
    end
    content.html_safe
  end

  def activity_content(activity)
    acted_on_type = activity.acted_on_type
    if activity.deleted_on
      render partial: "shared/items/deleted_item", locals: { activity: activity }
    elsif acted_on_type == "Comment"
      render partial: "shared/items/comment", locals: { comment: activity.acted_on, activity: activity }
    elsif acted_on_type == "Proof"
      render partial: "shared/items/proof_item", locals: { model: activity }
    elsif acted_on_type == "Version"
      render partial: "shared/items/version_item", locals: { model: activity }
    elsif acted_on_type == "User"
      render partial: "shared/items/user_item", locals: { activity: activity }
    elsif acted_on_type == "Problem"
      render partial: "shared/items/problem_item", locals: { activity: activity }
    elsif acted_on_type == "Topic"
      render partial: "shared/items/topic_item", locals: { activity: activity }
    end
  end

  def meta_data_icon model
    if model.class.name == "Activity" || model.class.name == "Version"
      "<div class='meta_data_img'><a href='#{user_path(model.user)}'><img src='#{user_avatar_src(model.user)}'></img></a></div>".html_safe
    elsif model.class.name != "User"
      "<i class='fa fa-calendar-o'></i>".html_safe
    end
  end

  def edit_account_content(user)
    if controller_name == "users"
      render partial: "users/edit", locals: { :@user => user }
    else
      render partial: "devise/registrations/edit"
    end
  end
 
  def problems_widget_items
    html = ""
    problems = Problem.where('created_at >= ?', 1.week.ago).limit(5)
    i = 2
    while problems.count == 0 do
      problems = Problem.where('created_at >= ?', i.week.ago).limit(5)
      i += 1
    end

    problems.each_with_index do |problem, index|
      html += "<div class='' style='padding: 10px; #{'border-top: 1px solid #ddd;' if index != 0 }'><a href='/problems/#{problem.id}'><h6 class='main-link' style='font-weight: 600;'>#{problem.title}</h6></a><span style='color: #777; font-size: .8em; line-height: 1.428;'>#{problem.created_at.strftime('%B %d, %Y')}</span></div>"
    end
    return html.html_safe
  end

  def hot_topics_items
    html = ""
    hot_topics = ""
    if signed_in?
       topics_following = "SELECT topic_id FROM topic_followings 
                          WHERE user_id = #{current_user.id}"
      hot_topics = Topic.where("id NOT IN (#{topics_following})").order("cached_problems_count DESC").limit(10).uniq
    else
      hot_topics = Topic.all.order(:cached_problems_count).limit(10).uniq
    end
    hot_topics.each_with_index do |topic, index|
      html += "<div class='' style='padding: 10px; #{'border-top: 1px solid #ddd;' if index != 0 }'><a href='/problems/#{topic.id}'><h6 class='main-link mb-0' style='font-weight: 600;'>#{topic.name}</h6></a><span style='color: #777; font-size: .8em; line-height: 1.428;'>#{topic.cached_problems_count} Problems</span></div>"
    end
    return html.html_safe
  end

  def top_users_items
    html = ""
    User.all.order("reputation DESC").limit(5).uniq.each_with_index do |user, index|
      html += "<li><div class='author-img'><a href='/users/#{user.id}'><img width='60' height='60' src='#{user_avatar_src user}' alt='User Avatar'></a></div><h6><a class='main-link' href='/users/#{user.id}'>#{user.username}</a></h6><span class='label font-weight-600' style='background: #{reputation_color user.reputation};'><i class='mr-5 fa fa-trophy'></i>#{user.reputation}</span></li>"
    end
    return html.html_safe
  end

  def stat_widget_text(stat)
    html = "<h6 class='text-muted font-weight-600'>#{stat}</h6>"
    if controller_name == "problems" and action_name == "show"
      if stat == "Edits"
        html = "<a href='/problems/#{@problem.id}/logs' class='text-muted font-weight-600' style='font-size: 0.85em;'>#{stat} <span class='fa fa-arrow-circle-right ml-5'></span></a>"
        return html.html_safe
      elsif stat == "Followers"
        html = "<a href='/problems/#{@problem.id}/followers' data-remote='true' class='text-muted font-weight-600' style='font-size: 0.85em;'>#{stat} <span class='fa fa-arrow-circle-right ml-5'></span></a>"
        return html.html_safe
      end
    end

    return html.html_safe
  end

  def avatar_src(actor_id)
    if actor_id < 0
      return "/assets/math_world.jpg"
    else
      return user_avatar_src(User.find(actor_id))
    end
  end
end
