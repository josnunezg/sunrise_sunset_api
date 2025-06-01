class QuerySearchController < ApplicationController
  def index
    result = QuerySearcher.call(search_params)
    if result.success?
      render json: { country: result.country.to_json, city: result.city.to_json, data: result.result }, status: :ok
    else
      render json: { error: result.error }, status: :bad_request
    end
  end

  private

  def search_params
    params.permit(:query, :date_start, :date_end)
  end
end
