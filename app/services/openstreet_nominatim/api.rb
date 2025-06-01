class OpenstreetNominatim::Api
  FORMAT = "json".freeze

  def initialize
    @conn = Faraday.new(url: SunriseSunset::Config.get("OPENSTREET_NOMINATIM_API_BASE_URL")) do |faraday|
      faraday.headers["User-Agent"] = "MiAppRuby/1.0 (contacto@miapp.com)"
      faraday.headers["Accept"] = "application/json"
      faraday.options.open_timeout = 10
      faraday.options.timeout = 10
      faraday.adapter Faraday.default_adapter
      faraday.response :json
    end
  end

  def search(city:, country:)
    @conn.get("/search?#{URI.encode_www_form({ city: city, country: country, format: FORMAT })}")
  end
end
