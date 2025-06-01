class CoordinatesSeacher
  include Interactor

  delegate :city, :country, to: :context

  def call
    response = nominatim_service.search(city: city, country: country)
    context.fail!(error: "We were not able to find the coordinates") unless response.success?

    result = response.body.first
    context.lat = result["lat"].to_f
    context.lng = result["lon"].to_f
    context.city_name = result["name"]
    context.country_name = result["display_name"].split(",").last.strip
  end

  private

  def nominatim_service
    @nominatim_service ||= OpenstreetNominatim::Api.new
  end
end
