class SunriseSunset::Config
  class << self
    def get(name = "")
      ENV.fetch(name) { nil }
    end
  end
end
