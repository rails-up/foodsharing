class CitiesController < ApplicationController

  def index
  end

  def subway
    city_subway = {
      1 => %w(Парк\ культуры Спортивная Воробьёвы\ горы),
      2 => %w(Улица\ Дыбенко Проспект\ Большевиков Ладожская)
    }

    stations = city_subway[params[:city_id].to_i]
    if stations
      render json: stations.to_json
    else
      render json: { errors: ['Нету метро', 'В этом городе'] }, status: :not_found
    end
    # render plain: "subway"
    # head :no_content
  end

end
