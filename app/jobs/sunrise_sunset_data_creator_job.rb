class SunriseSunsetDataCreatorJob < ApplicationJob
  queue_as :default

  def perform(results, latitude, longitude)
    @latitude = latitude
    @longitude = longitude
    records = results.map { |result| record_params(result) }

    SunriseSunsetInfo.insert_all(records, unique_by: :index_sunrise_sunset_infos_on_date_and_latitude_and_longitude)
  rescue ActiveRecord::RecordNotUnique => e
    Rails.logger.warn("Duplicated record: #{e.message}")
  end

  private

  def record_params(base_params)
    base_params.merge({
      "created_at" => timestamp,
      "updated_at" => timestamp,
      "latitude" => @latitude,
      "longitude" => @longitude
    })
  end

  def timestamp
    @timestamp ||= Time.current
  end
end
