module Slugifier
  extend ActiveSupport::Concern

  def slugify(value)
    I18n.transliterate(value).downcase.gsub(" ", "-")
  end
end
