class DoctorsController < ApplicationController
  respond_to :html, :json, :js

  autocomplete :doctor, :name, :full => true

  def index
    @page_size = 4
    @offset = params[:offset].to_i
    @sorting = params[:sorting] || "relevance"
    @update = params[:update]
    @name = params[:name]
    
    sorting = case @sorting
      when "relevance"
        # FIXME: Implement some relevance calculation
        "latest_at DESC"
      when "reports" 
        "num_reports DESC"
      else 
        "latest_at DESC"
      end

    # NOTE: We've incremented the @page_count by 1 to determine if more results will exist
    # beyond what we're displaying.
    @doctors = Doctor.where("name LIKE ?", "%#{@name}%").order(sorting).limit(@page_size+1).offset(@offset)
    @more_results = @doctors.size > @page_size
    @doctors.pop if @more_results
    
    logger.info("RES: #{ @doctors.size } MRE? #{ @more_results }")

    respond_with @doctors
  end

  def show
    @doctor = Doctor.find(params[:id])

    @page_size = 6
    @offset = params[:offset].to_i
    @reports = @doctor.reports.limit(@page_size).offset(@offset)
    @more_results = @doctor.reports.size > (@offset + @page_size)

    respond_with @doctor
  end

end
