FactoryBot.define do
  factory :sunrise_sunset_info do
    date { "2025-05-26" }
    sunrise { "MyString" }
    sunset { "MyString" }
    first_light { "MyString" }
    last_light { "MyString" }
    dawn { "MyString" }
    dusk { "MyString" }
    solar_noon { "MyString" }
    golder_hour { "MyString" }
    day_length { "MyString" }
    timezone { "MyString" }
    utc_offset { 1 }
  end
end
