FactoryBot.define do
  factory :sunrise_sunset_info do
    date { Faker::Date.in_date_period }
    sunrise { Faker::Time.between_dates(from: 1.day.ago, to: Date.today, period: :morning).strftime("%I:%M:%S %p") }
    sunset { Faker::Time.between_dates(from: 1.day.ago, to: Date.today, period: :afternoon).strftime("%I:%M:%S %p") }
    first_light { Faker::Time.between_dates(from: 1.day.ago, to: Date.today, period: :morning).strftime("%I:%M:%S %p") }
    last_light { Faker::Time.between_dates(from: 1.day.ago, to: Date.today, period: :night).strftime("%I:%M:%S %p") }
    dawn { Faker::Time.between_dates(from: 1.day.ago, to: Date.today, period: :morning).strftime("%I:%M:%S %p") }
    dusk { Faker::Time.between_dates(from: 1.day.ago, to: Date.today, period: :night).strftime("%I:%M:%S %p") }
    solar_noon { Faker::Time.between_dates(from: 1.day.ago, to: Date.today, period: :morning).strftime("%I:%M:%S %p") }
    golden_hour { Faker::Time.between_dates(from: 1.day.ago, to: Date.today, period: :night).strftime("%I:%M:%S %p") }
    day_length { Faker::Time.between_dates(from: 1.day.ago, to: Date.today, period: :evening).strftime("%I:%M:%S") }
    timezone { Faker::Address.time_zone }
    utc_offset { 1 }
  end
end
