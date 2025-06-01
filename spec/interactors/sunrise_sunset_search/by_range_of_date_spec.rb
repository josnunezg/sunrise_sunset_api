
RSpec.describe SunriseSunsetSearch::ByRangeOfDate, type: :interactor do
  let(:lat) { Faker::Address.latitude.to_f }
  let(:lng) { Faker::Address.longitude.to_f }
  let(:date_start) { Date.today }
  let(:date_end) { Date.today + 2 }
  let(:service_double) { instance_double("SunriseAndSunset::Api") }

  let(:context_params) do
    {
      lat: lat,
      lng: lng,
      date_start: date_start,
      date_end: date_end,
      sunrise_and_sunset_service: service_double
    }
  end

  describe "#call" do
    context "when data is stored on cache" do
      before do
        create(:sunrise_sunset_info, latitude: lat, longitude: lng, date: date_start)
        create(:sunrise_sunset_info, latitude: lat, longitude: lng, date: date_start + 1)
        create(:sunrise_sunset_info, latitude: lat, longitude: lng, date: date_end)
      end

      it "returns data from cache and set from_cache as true" do
        result = described_class.call(context_params)

        expect(result).to be_success
        expect(result.result.count).to eq(3)
        expect(result.from_cache).to be true
      end
    end

    context "when data is not stored on cache" do
      let(:api_response) do
        {
          "results" => [
            {
              "date" => date_start.strftime("%Y-%m-%d"),
              "sunrise" => "07:00:00",
              "sunset" => "19:00:00",
              "timezone" => "America/Santiago"
            },
            {
              "date" => (date_start + 1).strftime("%Y-%m-%d"),
              "sunrise" => "07:01:00",
              "sunset" => "19:01:00",
              "timezone" => "America/Santiago"
            },
            {
              "date" => date_end.strftime("%Y-%m-%d"),
              "sunrise" => "07:02:00",
              "sunset" => "19:02:00",
              "timezone" => "America/Santiago"
            }
          ]
        }
      end

      before do
        allow(service_double).to receive(:search_by_range_of_date)
          .with(date_start: date_start, date_end: date_end)
          .and_return(double("Response", success?: true, body: api_response))
      end

      it "calls api service and returns data" do
        result = described_class.call(context_params)

        expect(result).to be_success
        expect(result.result).to eq(api_response["results"])
        expect(result.from_cache).to be_nil
      end
    end

    context "when api service failed" do
      before do
        allow(service_double).to receive(:search_by_range_of_date)
          .with(date_start: date_start, date_end: date_end)
          .and_return(double("Response", success?: false))
      end

      it "returns error message" do
        result = described_class.call(context_params)

        expect(result).to be_failure
        expect(result.error).to eq("We were not able to find the sunrise and sunset data to your choosen city")
      end
    end

    context "when date_start and date_end are nil" do
      it "does not get data if date_start is nil" do
        result = described_class.call(context_params.merge(date_start: nil))

        expect(result).to be_success
        expect(result.result).to be_nil
      end

      it "does not get data if date_start is nil" do
        result = described_class.call(context_params.merge(date_end: nil))

        expect(result).to be_success
        expect(result.result).to be_nil
      end
    end
  end
end
