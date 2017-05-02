class LocationController < ApplicationController
  def autocomplete
    render json: LocationService.new.autocomplete(params[:query])
  end
end
