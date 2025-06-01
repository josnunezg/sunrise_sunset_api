require "webmock/rspec"

RSpec.describe OpenstreetNominatim::Api, type: :service do
  let(:api_base_url) { "https://nominatim.openstreetmap.org" }
  let(:api_instance) { described_class.new }
  let(:city) { Faker::Address.city }
  let(:country) { Faker::Address.country }

  let(:response_body) do
    [
      {
        "place_id": 1602317,
        "licence": "Data © OpenStreetMap contributors, ODbL 1.0. http://osm.org/copyright",
        "osm_type": "relation",
        "osm_id": 162993,
        "lat": "-33.4543164",
        "lon": "-70.5936358",
        "class": "boundary",
        "type": "administrative",
        "place_rank": 16,
        "importance": 0.4922600698883219,
        "addresstype": "suburb",
        "name": city,
        "display_name": "#{city}, #{country}",
        "boundingbox": [
          "-33.4749230",
          "-33.4337494",
          "-70.6315528",
          "-70.5707379"
        ]
      }
    ]
  end

  before do
    allow(SunriseSunset::Config).to receive(:get)
      .with("OPENSTREET_NOMINATIM_API_BASE_URL")
      .and_return(api_base_url)
  end

  describe "#search" do
    it "returns successful response (200 OK)" do
      stub_request(:get, "#{api_base_url}/search")
        .with(query: hash_including(city: city, country: country, format: "json"))
        .to_return(status: 200, body: response_body.to_json, headers: { "Content-Type" => "application/json" })

      response = api_instance.search(city: city, country: country)

      expect(response.status).to eq(200)
      expect(response.body).to be_an(Array)
      expect(response.body.first["name"]).to eq(city)
    end

    it "handles server error (500)" do
      stub_request(:get, "#{api_base_url}/search")
        .with(query: hash_including(city: city, country: country, format: "json"))
        .to_return(status: 500, body: "Internal Server Error")

      response = api_instance.search(city: city, country: country)

      expect(response.status).to eq(500)
      expect(response.body).to eq("Internal Server Error")
    end
  end
end
