
Rails.application.config.after_initialize do
  Country.initialize_from_json
end
