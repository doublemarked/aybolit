class PagesController < ApplicationController
  def show
    page = params['page']

    if not page 
      render 'index'
    elsif template_exists?('pages/'+page)
      render 'pages/'+page
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

end
