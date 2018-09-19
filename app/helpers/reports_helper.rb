module ReportsHelper
  def flags_list(reportable)
    names = ["spam", "rude or abusive", "very low quality"]
    if reportable.class.name == "Problem"
      names << "duplicate" 
      names << "not a proof problem"
    elsif reportable.class.name
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

end
