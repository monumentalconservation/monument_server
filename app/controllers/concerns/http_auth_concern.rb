module HttpAuthConcern  
  TOKEN = ENV['AUTH_TOKEN'].freeze
  
  extend ActiveSupport::Concern
  included do
    before_action :http_authenticate
  end
  
  def http_authenticate
    return true unless Rails.env == 'production'
    unless request.params[:token].present? && request.params[:token] == TOKEN     

      authenticate_or_request_with_http_basic do |username, password|
        username == ENV['AUTH_USERNAME'] && password == ENV['AUTH_PASSWORD']
      end

    end

  end
end