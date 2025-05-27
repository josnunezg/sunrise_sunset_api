class SunriseSunset::Config
  class << self
    def get(name = "")
      ENV.fetch(name)
    end
  end
end
