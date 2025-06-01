class CountriesJsonGetter
  include Interactor

  JSON_FILE_PATH = %w[lib assets countries.json]

  def call
    file_path = Rails.root.join(*JSON_FILE_PATH)
    context.countries = JSON.parse(File.read(file_path))
  rescue StandardError => e
    Rails.logger.error(e)
    context.fail!(error: e, countries: [])
  end
end
