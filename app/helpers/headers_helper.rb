module HeadersHelper
  def fancy_header_styles 
    if controller_name == "help_center"
      if action_name == "help"
        'background: rgba(20, 94, 101, 0.22); margin-bottom: 100px;';
      end
    end
  end

  def fancy_header_left_content
    if controller_name == "help_center"
      if action_name == "help"
        "<h1 class='header-h1' style='font-weight:600; padding-left:22px;'>Hello, <br/> How Can we help you?</h1>".html_safe
      end
    end
  end

  def fancy_header_right_class 
    if controller_name == "help_center"
      if action_name == "help"
        "help-center-background"
      end
    end
  end
end
