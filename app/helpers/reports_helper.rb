module ReportsHelper
  def flags_list(reportable)
    names = ["spam", "offensive", "very low quality"]
    if reportable.class.name == "Problem"
      names << "duplicate" 
      names << "not a proof problem"
    elsif reportable.class.name == "Proof"
      names << "not a proof"
    end
    names << "other"
    return Flag.where(name: names)
  end

  def report_button(model, options={})
    if signed_in?
      "<a class='btn-text btn-xs float-right small-padding reportModalToggle' data-remote='true' href='/reports/new?reportable_id=#{model.id}&amp;reportable_type=#{model.class.name}'><span class='proof-edit'><i class='mr-5 glyphicon glyphicon-edit'></i>Report</span></a>".html_safe
    end
  end

  def reported_type_icon(type)
    return "<span class='fa fa-question ft-material-span'></span>".html_safe if type == "Problem"
    return "<span class='fa fa-comment ft-material-span'></span>".html_safe if type == "Comment"
    if type == "Proof"
      return "<span class='ft-material-span'><img class='inline-icon' src='/assets/proof_icon3.png'></img></span>".html_safe
    end
  end

  def reported_path(report)
    if report.reportable_type == "Problem"
      "/problems/#{report.reportable.id}"
    elsif report.reportable_type == "Topic"
      "/topics/#{report.reportable.id}"
    elsif report.reportable_type == "Comment"
      "/problems/#{report.reportable.get_problem.id}"
    elsif report.reportable_type == "Proof"
      "/problems/#{report.reportable.problem.id}"
    end
  end

  def reporter_link(report)
    "<a href='#{user_path(report.user.id)}' class='main-link'>#{report.user.username}</a>".html_safe
  end

  def reported_user_link(report)
    user = report.reportable.user
    "<a href='#{user_path(user.id)}' class='main-link'>#{user.username}'s</a>".html_safe
  end

  def reported_resource_title(report)
    msg = report.reportable_type
    if report.reportable_type == "Problem"
      msg = "#{report.reportable_type}"
      msg +=": <a href='#{problem_path(report.reportable.id)}' class='main-link'>#{report.reportable.title}</a>"
    elsif report.reportable_type == "Proof"
      msg = "<a href='#{problem_path(report.reportable.problem.id)}' class='main-link'>#{report.reportable_type}</a>"
      msg += " for problem <a href='#{problem_path(report.reportable.problem.id)}' class='main-link'>#{report.reportable.problem.title}</a>"
    elsif report.reportable_type == "Comment"
      msg = "<a href='#{problem_path(report.reportable.get_problem.id)}' class='main-link'>#{report.reportable_type}</a>"
      if report.reportable.commented_on_type == "Proof"
        msg += " on a proof for problem <a href='#{problem_path(report.reportable.get_problem.id)}' class='main-link'>#{report.reportable.get_problem.title}</a>"
      else
        msg += " on problem <a href='#{problem_path(report.reportable.get_problem.id)}' class='main-link'>#{report.reportable.get_problem.title}</a>"
      end
    end
    return msg.html_safe
  end

  def report_resource_message(report)
    resource = report.reportable
    resource_type = report.reportable_type
    if resource_type == "Problem"
      msg = "#{resource.title}"
    elsif resource_type == "Proof"
      msg = "Proof for problem: <i>#{resource.problem.title}</i>"
    elsif resource_type == "Comment"
      if resource.commented_on_type == "Problem"
        msg = "Comment on problem: <i>#{resource.get_problem.title}</i>"
      elsif resource.commented_on_type == "Proof"
        msg = "Comment on a proof for problem: <i>#{resource.get_problem.title}</i>"
      end
    end
    return msg.html_safe
  end
end
