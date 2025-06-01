class SunriseSunsetProcessor
  include Interactor::Organizer

  organize CoordinatesSeacher, SunriseSunsetDataSearcher
end
