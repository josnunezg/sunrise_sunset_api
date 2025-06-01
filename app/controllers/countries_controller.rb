class CountriesController < ApplicationController
  def index
    render json: Country.to_json, status: :ok
  end
end
