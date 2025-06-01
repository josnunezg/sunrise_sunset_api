class SunriseAndSunset::Api
  attr_reader :base_query

  def initialize(lat:, lng:)
    @conn = Faraday.new(url: SunriseSunset::Config.get("SUNRISE_SUNSET_API_BASE_URL")) do |faraday|
      faraday.options.open_timeout = 10
      faraday.options.timeout = 10
      faraday.adapter Faraday.default_adapter
      faraday.response :json
    end
    @base_query = { lat: lat, lng: lng }
  end

  def search
    @conn.get("/json?#{URI.encode_www_form(base_query)}")
  end

  def search_by_day(day:)
    @conn.get("/json?#{URI.encode_www_form(base_query.merge({ date: day }))}")
  end

  def search_by_range_of_date(date_start:, date_end:)
    @conn.get("/json?#{URI.encode_www_form(base_query.merge({ date_start: date_start, date_end: date_end }))}")
  end
end
