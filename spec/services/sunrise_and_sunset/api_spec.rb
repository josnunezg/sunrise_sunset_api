require "webmock/rspec"

RSpec.describe SunriseAndSunset::Api, type: :service do
  let(:api_base_url) { "https://api.sunrisesunset.io" }
  let(:lat) { Faker::Address.latitude.to_s }
  let(:lng) { Faker::Address.longitude.to_s }
  let(:api_instance) { described_class.new(lat: lat, lng: lng) }

  before do
    allow(SunriseSunset::Config).to receive(:get)
      .with("SUNRISE_SUNSET_API_BASE_URL")
      .and_return(api_base_url)
  end

  describe "#search" do
    let(:today) { Date.today.strftime("%Y-%m-%d") }
    let(:response_body) do
      {
          "results": {
              "date": today,
              "sunrise": "7:38:49 AM",
              "sunset": "5:44:07 PM",
              "first_light": "6:10:55 AM",
              "last_light": "7:12:01 PM",
              "dawn": "7:11:39 AM",
              "dusk": "6:11:17 PM",
              "solar_noon": "12:41:28 PM",
              "golden_hour": "5:06:46 PM",
              "day_length": "10:05:17",
              "timezone": "America/Santiago",
              "utc_offset": -240
          },
          "status": "OK"
      }
    end

    it "returns successful response (200 OK)" do
      stub_request(:get, "#{api_base_url}/json")
        .with(query: hash_including(
                "lat" => lat,
                "lng" => lng
              ))
        .to_return(status: 200, body: response_body.to_json, headers: { "Content-Type" => "application/json" })

      response = api_instance.search

      expect(response.status).to eq(200)
      expect(response.body["results"]).to be_an(Hash)
      expect(response.body.dig("results", "date")).to eq(today)
    end
  end

  describe "#search_by_day" do
    let(:day) { Faker::Date.in_date_period.strftime("%Y-%m-%d") }

    let(:response_body) do
      {
          "results": {
              "date": day,
              "sunrise": "7:38:49 AM",
              "sunset": "5:44:07 PM",
              "first_light": "6:10:55 AM",
              "last_light": "7:12:01 PM",
              "dawn": "7:11:39 AM",
              "dusk": "6:11:17 PM",
              "solar_noon": "12:41:28 PM",
              "golden_hour": "5:06:46 PM",
              "day_length": "10:05:17",
              "timezone": "America/Santiago",
              "utc_offset": -240
          },
          "status": "OK"
      }
    end

    it "returns successful response (200 OK)" do
      stub_request(:get, "#{api_base_url}/json")
        .with(query: hash_including(
                "lat" => lat,
                "lng" => lng,
                "date" => day
              ))
        .to_return(status: 200, body: response_body.to_json, headers: { "Content-Type" => "application/json" })

      response = api_instance.search_by_day(day: day)

      expect(response.status).to eq(200)
      expect(response.body["results"]).to be_an(Hash)
      expect(response.body.dig("results", "date")).to eq(day)
    end
  end

  describe "#search_by_range_of_date" do
    let(:date_base) { Faker::Date.in_date_period }
    let(:date_start) { date_base.beginning_of_month.strftime("%Y-%m-%d") }
    let(:date_end) { date_base.end_of_month.strftime("%Y-%m-%d") }
    let(:date_range) { (date_start..date_end).to_a }

    let(:response_body) do
      {
        "results": date_range.map do |date|
          {
            "date": date,
            "sunrise": "7:38:49 AM",
            "sunset": "5:44:07 PM",
            "first_light": "6:10:55 AM",
            "last_light": "7:12:01 PM",
            "dawn": "7:11:39 AM",
            "dusk": "6:11:17 PM",
            "solar_noon": "12:41:28 PM",
            "golden_hour": "5:06:46 PM",
            "day_length": "10:05:17",
            "timezone": "America/Santiago",
            "utc_offset": -240
          }
        end,
        "status": "OK"
      }
    end

    it "returns successful response (200 OK)" do
      stub_request(:get, "#{api_base_url}/json")
        .with(query: hash_including(
                "lat" => lat,
                "lng" => lng,
                "date_start" => date_start,
                "date_end" => date_end
              ))
        .to_return(status: 200, body: response_body.to_json, headers: { "Content-Type" => "application/json" })

      response = api_instance.search_by_range_of_date(date_start: date_start, date_end: date_end)

      expect(response.status).to eq(200)
      expect(response.body["results"]).to be_an(Array)
      expect(response.body["results"].map { |result| result["date"] }).to match_array(date_range)
    end
  end
end
