class OpenstreetNominatim::Api
  FORMAT = "json".freeze

  def initialize
    puts Resolv.getaddress(SunriseSunset::Config.get("OPENSTREET_NOMINATIM_API_BASE_URL"))
    full_url = "https://#{SunriseSunset::Config.get("OPENSTREET_NOMINATIM_API_BASE_URL")}"
    @conn = Faraday.new(url: full_url, ssl: { verify: Rails.env.production? }) do |faraday|
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
