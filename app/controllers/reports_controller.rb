class ReportsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_reputation_for_reports, only: [:new, :create, :update]
  before_action :correct_report, only: [:update]
  before_action :reviewer_priviliges, only: [:index, :help, :users, :claimed,
                                             :history, :show, :close, :decline,
                                             :reserve]


  def show
    @report = Report.find(params[:id])
    if not params[:tab].nil?
      @tab = params[:tab]
    end
  end

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
      PostHandler::HandlePost.new(post: @report.reportable, handle: :all).call
      if @report.reportable_type == "Problem" and @report.reportable.soft_deleted?
        flash[:notice] = "#{@report.reportable.user.username}'s #{@report.reportable_type.downcase} has been reported and deleted due to a substantial amount of negative feedback from the community."
        redirect_to root_url
      end
      #Report.handle(@report.reportable)
    end
  end

  def update
    @report = Report.find(params[:id])
    @report.update(status: "closed", expired_on: Time.now, details: "Report was closed by the reporter.")
  end

  def index
    @reports = Report.all.active
  end

  def close
  end

  def decline
  end

  def reserve
  end
  
  def help
  end

  def reserved
  end

  def users
  end

  def history
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

    def reviewer_priviliges
      if !current_user.has_review_priviliges?
        flash[:alert] = "Action not authorized"
        redirect_to root_url
      end
    end

end
