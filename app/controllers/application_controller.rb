class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :authenticate

  def status
    render json: "ok", status: :ok
  end

  private

  def authenticate
    authenticate_or_request_with_http_token do |token, _|
      token == SunriseSunset::Config.get("FRONTEND_API_KEY")
    end
  end
end
