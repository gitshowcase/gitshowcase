class ProfileController < ApplicationController
  before_action :set_user, only: [:show]

  def show
  end

  private

  def set_user
    if params[:username]
      @user = User.find_by_username params[:username].downcase
    else
      @user = User.find_by_domain request.host
    end

    unless @user.present?
      if Rails.env.production?
        app_domain = ENV['APP_DOMAIN'] || 'localhost'
        redirect_to "https://www.#{app_domain}/404"
      else
        redirect_to '/404'
      end
    end
  end
end
