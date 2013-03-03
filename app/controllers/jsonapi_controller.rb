class JsonapiController < ApplicationController
  respond_to :json

  def current_user
    respond_with super
  end

end
