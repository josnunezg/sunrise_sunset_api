class QuerySearcher
  include Interactor

  delegate :query, :date_start, :date_end, to: :context

  def call
    service = SunriseSunsetProcessor.call(city: query, date_start: date_start, date_end: date_end)
    context.fail!(error: service.error) unless service.success?

    context.country = Country.new(name: service.country_name)
    context.city = City.new(name: service.city_name, country: context.country)
    context.result = service.result
  end
end
