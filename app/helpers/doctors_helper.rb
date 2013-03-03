module DoctorsHelper

  def doctor_sorting_options(val)
    options_for_select( 
      [[I18n.t('controls.sort_by_relevance'), "relevance"],
       [I18n.t('controls.sort_by_recent_reports'), "recent"],
       [I18n.t('controls.sort_by_num_reports'), "reports"]], val)
  end

end
