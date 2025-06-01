class SunriseSunsetSearch::ByToday
  include Interactor

  delegate :sunrise_and_sunset_service, :day, :date_start, :date_end, :lat, :lng, to: :context

  def call
    return if day.present?
    return if date_start.present? && date_end.present?

    result_from_cache = search_on_cache

    if result_from_cache.any?
      context.result = result_from_cache.to_json
      context.from_cache = true and return
    end

    response = sunrise_and_sunset_service.search
    context.fail!(error: "We were not able to find the sunrise and sunset data to your choosen city") unless response.success?

    context.result = response.body["results"]
  end

  private

  def search_on_cache
    ::SunriseSunsetInfo.where(latitude: lat, longitude: lng, date: Date.today).limit(1)
  end
end
