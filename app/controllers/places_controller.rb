class PlacesController < ApplicationController
  def metro
    @stations = Place.where(city_id: params[:place_id])

    respond_to do |format|
      if @stations.present?
        format.json { @stations }
      else
        format.json { render json: { error: 'station not found' }, status: :not_found }
      end
    end
  end
end
