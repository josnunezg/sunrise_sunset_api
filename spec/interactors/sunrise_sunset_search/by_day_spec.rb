
RSpec.describe SunriseSunsetSearch::ByDay, type: :interactor do
  let(:lat) { Faker::Address.latitude.to_f }
  let(:lng) { Faker::Address.longitude.to_f }
  let(:day) { Date.today }
  let(:service_double) { instance_double("SunriseAndSunset::Api") }

  let(:context_params) do
    {
      lat: lat,
      lng: lng,
      day: day,
      sunrise_and_sunset_service: service_double
    }
  end

  describe "#call" do
    context "when data is present in cache" do
      before do
        create(:sunrise_sunset_info, latitude: lat, longitude: lng, date: day)
      end

      it "returns the cached data and sets from_cache to true" do
        result = described_class.call(context_params)

        expect(result).to be_success
        expect(result.result).to be_a(String)
        expect(JSON.parse(result.result).first["date"]).to eq(day.to_s)
        expect(result.from_cache).to be true
      end
    end

    context "when data is not present in cache" do
      let(:api_response) do
        {
          "results" => {
            "date" => day.to_s,
            "sunrise" => "07:00:00",
            "sunset" => "19:00:00",
            "timezone" => "America/Santiago"
          }
        }
      end

      before do
        allow(service_double).to receive(:search_by_day)
          .with(day: day)
          .and_return(double("Response", success?: true, body: api_response))
      end

      it "calls the external service and returns results" do
        result = described_class.call(context_params)

        expect(result).to be_success
        expect(result.result).to eq(api_response["results"])
        expect(result.from_cache).to be_nil
      end
    end

    context "when the external service fails" do
      before do
        allow(service_double).to receive(:search_by_day)
          .with(day: day)
          .and_return(double("Response", success?: false))
      end

      it "fails with an error message" do
        result = described_class.call(context_params)

        expect(result).to be_failure
        expect(result.error).to eq("We were not able to find the sunrise and sunset data to your choosen city")
      end
    end

    context "when the day is nil" do
      it "returns early and does nothing" do
        result = described_class.call(context_params.merge(day: nil))

        expect(result).to be_success
        expect(result.result).to be_nil
      end
    end
  end
end
