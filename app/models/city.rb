class City
  include Slugifier

  attr_reader :name, :slug, :country

  def initialize(name:, country:)
    @name = name
    @slug = slugify(name)
    @country = country
  end

  def to_json
    {
      name: name,
      slug: slug
    }
  end
end
