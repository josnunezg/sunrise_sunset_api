
RSpec.describe SunriseSunsetDataSearcher, type: :interactor do
  let(:lat) { Faker::Address.latitude.to_f }
  let(:lng) { Faker::Address.longitude.to_f }
  let(:date_start) { Date.today }
  let(:date_end) { Date.today }

  let(:context_params) do
    {
      lat: lat,
      lng: lng,
      date_start: date_start,
      date_end: date_end
    }
  end

  before do
    allow(SunriseSunsetSearch::ByToday).to receive(:call!).and_return(
      Interactor::Context.new(success?: true, result: "TODAY_RESULT")
    )
    allow(SunriseSunsetSearch::ByDay).to receive(:call!).and_return(
      Interactor::Context.new(success?: true, result: "DAY_RESULT")
    )
    allow(SunriseSunsetSearch::ByRangeOfDate).to receive(:call!).and_return(
      Interactor::Context.new(success?: true, result: "RANGE_RESULT")
    )

    allow(SunriseSunsetDataCreatorJob).to receive(:perform_now)
  end

  it "calls the interactors in order and enqueues the job" do
    described_class.call(context_params)

    expect(SunriseSunsetSearch::ByToday).to have_received(:call!).once
    expect(SunriseSunsetSearch::ByDay).to have_received(:call!).once
    expect(SunriseSunsetSearch::ByRangeOfDate).to have_received(:call!).once
    expect(SunriseSunsetDataCreatorJob).to have_received(:perform_now)
  end
end
