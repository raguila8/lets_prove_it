class ReportsController < ApplicationController
  def new
    reportable_klass = params[:reportable_type].camelize.constantize
    @reportable = reportable_klass.find(params[:reportable_id])
  end

  def create
    @report = Report.new(report_params)
    @report.user = current_user
    @report.save
  end

  private

    def report_params
      params.require(:report).permit(:reportable_type, :reportable_id, :reason)
    end
end
