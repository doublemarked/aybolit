module ApplicationHelper
  def delivery_percentage
    "%2.0f" % ( 100 * Report.delivered.count / Report.count)
  end

  def full_image_path(img_path)
    request.protocol + request.host_with_port + image_path(img_path)
  end

  def locale_menu_link(locale)
    li_class = locale == I18n.locale ? 'active' : ''
    link_to locale_redirect_url(locale), :class => li_class do
      image_tag( locale.to_s + "-flag.png", :alt => t(:locale_name, :locale => locale) )
    end
  end

end
