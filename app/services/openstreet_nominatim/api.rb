module OpenstreetNominatim
  class Api
    FORMAT = "json".freeze
    base_uri SunriseSunset::Config.get("OPENSTREET_NOMINATIM_API_BASE_URL")

    def search(city:, country:)
      self.class.get("/search?city=#{city}&country=#{country}&format=#{FORMAT}")
    end
  end
end
