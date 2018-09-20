class ReportsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :update]
  before_action :correct_reputation_for_reports, only: [:new, :create, :update]
  before_action :correct_report, only: [:update]


  def new
    reportable_klass = params[:reportable_type].camelize.constantize
    @reportable = reportable_klass.find(params[:reportable_id])
  end

  def create
    @flag_error = Flag.validate_flags params[:report][:flags], params[:report][:reason]
    if @flag_error.empty?
      @report = Report.new(report_params)
      @report.user = current_user
      @report.status = "pending"
      @report.save
      @report.add_flags params[:report][:flags]
      Report.handle(@report.reportable)
    end
  end

  def update
    @report = Report.find(params[:id])
    @report.update(status: "closed", expired_on: Time.now, details: "Report was closed by the reporter.")
  end

  private

    def report_params
      params.require(:report).permit(:reportable_type, :reportable_id, :reason)
    end

    def correct_reputation_for_reports
      if current_user.reputation < 750
        flash[:alert] = "Action not authorized"
        redirect_to root_url
      end
    end

    def correct_report
      @report = Report.find(params[:id])
      if @report.user != current_user
        flash[:alert] = "Action not authorized"
        redirect_to root_url
      end
    end

end
