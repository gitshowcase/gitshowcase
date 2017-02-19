class ApplicationController < ActionController::Base
  force_ssl if: :ssl_required?

  protect_from_forgery with: :exception

  private

  def ssl_required?
    Rails.env.production? && request.domain == ENV['APP_DOMAIN']
  end
end
