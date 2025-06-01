class CitiesController < ApplicationController
  before_action :set_country
  before_action :set_city, only: %i[sunrise_and_sunset]

  def index
    render json: @country.to_json_with_cities, status: :ok
  end

  def sunrise_and_sunset
    result = SunriseSunsetProcessor.call(city: @city.name, country: @country.name, date_start: params[:date_start], date_end: params[:date_end])
    if result.success?
      render json: { country: @country.to_json, city: @city.to_json, data: result.result.reverse }, status: :ok
    else
      render json: { error: result.error }, status: :bad_request
    end
  end

  private

  def set_country
    @country = Country.find_by_slug(params[:country_slug])
    render json: { error: "Country does not exist" }, status: :not_found if @country.nil?
  end

  def set_city
    @city = @country.find_city_by_slug(params[:slug])
    render json: { error: "City does not exist" }, status: :not_found if @city.nil?
  end
end
