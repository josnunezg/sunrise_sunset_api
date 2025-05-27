class SunriseAndSunset::Api
  include HTTParty
  base_uri SunriseSunset::Config.get("SUNRISE_SUNSET_API_BASE_URL")

  attr_reader :base_query

  def initialize(lat:, lng:)
    @base_query = { lat: lat, lng: lng }
  end

  def search
    self.class.get("/json", { query: base_query })
  end

  def search_by_day(day:)
    self.class.get("/json", { query: base_query.merge({ date: day }) })
  end

  def search_by_range_of_date(date_start:, date_end:)
    self.class.get("/json", { query: base_query.merge({ date_start: date_start, date_end: date_end }) })
  end
end
