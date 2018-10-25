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
    return "<span class='fa fa-question mr-20'></span>".html_safe if type == "Problem"
    return "<span class='fa fa-comment mr-20'></span>".html_safe if type == "Comment"
    if type == "Proof"
      return "<img class='inline-icon mr-20' src='/assets/proof_icon3.png'></img>".html_safe
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
end
