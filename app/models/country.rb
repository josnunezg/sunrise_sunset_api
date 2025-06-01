class Country
  include Slugifier

  attr_reader :name, :slug, :cities

  class << self
    def all
      @all ||= create_countries
    end

    def to_json
      all.map(&:to_json)
    end

    def find_by_slug(slug)
      all.find { |country| country.slug == slug }
    end

    def initialize_from_json
      reset_cache
      all
    end

    private

    def create_countries
      Rails.logger.info "INIT COUNTRIES AND CITIES"
      countries_json = CountriesJsonGetter.call.countries
      countries_json.map { |name, city_names| new(name: name, city_names: city_names) }
    end

    def reset_cache
      @all = nil
    end
  end

  def initialize(name:, city_names: [])
    @name = name
    @slug = slugify(name)
    @cities = create_cities(city_names)
  end

  def find_city_by_slug(city_slug)
    cities.find { |city| city.slug == city_slug }
  end

  def to_json
    {
      name: name,
      slug: slug
    }
  end

  def cities_json
    cities.map(&:to_json)
  end

  def to_json_with_cities
    {
      country: to_json,
      cities: cities_json
    }
  end

  private

  def create_cities(city_names)
    city_names.map { |city_name| City.new(name: city_name, country: self) }
  end
end
