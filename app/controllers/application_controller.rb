class ApplicationController < ActionController::Base
  rescue_from Faraday::ClientError, Faraday::Error, with: :client_error_page
  rescue_from Faraday::ServerError, with: :server_error_page

  private

  def client_error_page
    @error = 'A client error occurred, please check your internet connection and network configuration '
    render 'pages/error'
  end

  def server_error_page
    @error = 'A server error occurred, please try again later'
    render 'pages/error'
  end
end
