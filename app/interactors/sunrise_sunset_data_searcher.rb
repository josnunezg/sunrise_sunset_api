class SunriseSunsetDataSearcher
  include Interactor::Organizer
  DATE_FORMAT = "%Y-%m-%d".freeze

  organize SunriseSunsetSearch::ByToday, SunriseSunsetSearch::ByDay, SunriseSunsetSearch::ByRangeOfDate

  before :set_sunrise_and_sunset_service
  before :set_used_date_to_search
  after :save_data_on_cache

  delegate :lat, :lng, :date_start, :date_end, to: :context

  private

  def set_sunrise_and_sunset_service
    context.sunrise_and_sunset_service = SunriseAndSunset::Api.new(lat: lat, lng: lng)
  end

  def set_used_date_to_search
    return if date_start.nil? || date_end.nil?
    return if date_start != date_end

    context.day = date_start
  end

  def save_data_on_cache
    return if context.from_cache

    SunriseSunsetDataCreatorJob.perform_now(context.result, lat, lng)
  end
end
