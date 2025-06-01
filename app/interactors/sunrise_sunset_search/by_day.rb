class SunriseSunsetSearch::ByDay
  include Interactor

  delegate :sunrise_and_sunset_service, :day, :lat, :lng, to: :context

  def call
    return if day.nil?

    result_from_cache = search_on_cache
    if result_from_cache.any?
      context.result = result_from_cache.to_json
      context.from_cache = true and return
    end

    response = sunrise_and_sunset_service.search_by_day(day: day)
    context.fail!(error: "We were not able to find the sunrise and sunset data to your choosen city") unless response.success?
    context.result = response.body["results"]
  end

  private

  def search_on_cache
    ::SunriseSunsetInfo.where(latitude: lat, longitude: lng, date: day)
  end
end
