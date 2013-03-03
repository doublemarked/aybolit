class ReportsController < ApplicationController
  respond_to :html, :json, :js

  def index
    @reports = Report.all
    respond_with @reports
  end

  def show
    @report = Report.find(params[:id])
    Report.increment_counter(:views, @report.id)

    respond_with @report
  end

  def new
    @report = Report.new
    @hospitals = Hospital.all

    respond_with @report
  end

  def share
    @report = Report.new
    respond_with @report
  end

  def create
    @report = Report.new(params[:report])

    hospital = Hospital.find(params[:hospital])
    @report.doctor = hospital.doctors.find_or_create_by_name(params[:doctor])

    # We store the report under the system account, invisible, until 
    # the user has authenticated.
    @report.user = system_user
    @report.visible = false

    if @report.save
      flash[:notice] = I18n.t('reports.submission')

      # We cache this saved report and later associate the report with the resulting user.
      session[:pending_report] = @report.id
      redirect_to '/auth/' + params[:provider]
    else
      respond_with @report
    end
  end

  def endorse
    @report = Report.find(params[:id])
    @endorsement = current_user.endorse(@report) if logged_in?

    respond_with @endorsement
  end

end
