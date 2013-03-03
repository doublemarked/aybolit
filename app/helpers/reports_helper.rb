module ReportsHelper
  def report_sorting_options(val)
    options_for_select( 
      [[I18n.t('controls.sort_by_recent_reports'), "recent"],
       [I18n.t('controls.sort_by_popularity'), "popular"],
       [I18n.t('controls.sort_by_undelivered'), "undelivered"]], val)
  end

  def oblast_select_options
    options_for_select( Hospital.select("oblast").uniq.map { |r| [r[:oblast],r[:oblast]] } )
  end

  def month_year_select_options
    results = []
    date = Date.today
    while date > (Date.today - 12.month)
      results << [date.strftime("%b %Y"), date.strftime("%Y-%m-01")]
      date -= 1.month
    end

    return results
  end

  def endorsement_message(report)
    I18n.t('messages.social_media_endorsement', :doctor => report.doctor.name, :hospital => report.hospital.name)
  end
end
