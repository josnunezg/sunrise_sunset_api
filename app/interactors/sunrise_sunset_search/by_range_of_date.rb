class SunriseSunsetSearch::ByRangeOfDate
  include Interactor

  delegate :sunrise_and_sunset_service, :date_start, :date_end, :lat, :lng, to: :context

  def call
    return if date_start.nil? || date_end.nil?

    result_from_cache = search_on_cache
    if result_from_cache.any?
      context.result = result_from_cache
      context.from_cache = true and return
    end

    response = sunrise_and_sunset_service.search_by_range_of_date(date_start: date_start, date_end: date_end)
    context.fail!(error: "We were not able to find the sunrise and sunset data to your choosen city") unless response.success?

    context.result = response.body["results"]
  end

  private

  def search_on_cache
    ::SunriseSunsetInfo.where(latitude: lat, longitude: lng, date: (date_start..date_end))
  end
end
