class HospitalsController < ApplicationController
  respond_to :html, :json, :js

  autocomplete :location, :name, :full => true

  # This is an override of the default generated autocomplete method in
  # order to incorporate a custom hospital scope for these requests.
  # Essentially Replaces: autocomplete :doctor, :name, :full => true
  # NOTE: This may break if the rails3-jquery-autocomplete gem changes.
  def autocomplete_doctor_name

    if params[:term].present?
      items = get_autocomplete_items(:model => Doctor, 
                                     :method => :name,
                                     :term => params[:term], 
                                     :options =>  { :full => true, :where => { :hospital_id => params[:id] } })
    end

    render :json => json_for_autocomplete(items || {}, :name)
  end

  def index
    @page_size = 4
    @offset = params[:offset].to_i
    @latitude = params[:latitude] || ""
    @longitude = params[:longitude] || ""
    @sorting = params[:sorting] || "recent"
    @update = params[:update]
   
    if @latitude.present?
      geolocator = [ @latitude, @longitude ]
      @location = parse_geolookup( Geocoder.search(geolocator) )
    elsif params[:location].present?
      geolocator = params[:location]
      @location = geolocator
    else
      geolocator = I18n.t('hospitals.default_location')
      @location = geolocator
    end

    @location ||= parse_geolookup( Geocoder.search(geolocator) )

    sorting = case @sorting
      when "reports" 
        "num_reports DESC"
      when "distance"
        "distance ASC"
      else 
        "latest_at DESC"
      end

    # NOTE: We've incremented the @page_count by 1 to determine if more results will exist
    # beyond what we're displaying.
    @hospitals = Hospital.near(geolocator).reorder(sorting).limit(@page_size+1).offset(@offset)
    @more_results = @hospitals.size > @page_size
    @hospitals.pop if @more_results
    
    logger.info("RES: #{ @hospitals.size } MRE? #{ @more_results }")

    respond_with @hospitals
  end

  def show
    @hospital = Hospital.find(params[:id])
    @map_hospitals = @hospital.nearbys(100) << @hospital

    @page_size = 4
    @offset = params[:offset].to_i
    @reports = @hospital.reports.limit(@page_size).offset(@offset).order("created_at DESC")
    @more_results = @hospital.reports.size > (@offset + @page_size)

    respond_with @hospital
  end

  # FIXME: This entire approach is dirty 
  def locations
    if params[:oblast].present? and params[:district].present?
      @locations = { :hospitals => Hospital.where(:oblast => params[:oblast], :district => params[:district]).map { |r|
        { id:r.id, name:r.name,address:r.display_address } 
      } }
    elsif params[:oblast].present?
      @locations = { :districts => Hospital.select("district").where(:oblast => params[:oblast]).order(:district).uniq.map { |r| r[:district] } }
    else 
      @locations = { }
    end

    respond_with @locations
  end

protected
  def parse_geolookup(results)
    "#{ results.first.city }, #{ results.first.state }, #{ results.first.country }" if results.present?
  end

end
