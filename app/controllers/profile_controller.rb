class ProfileController < ApplicationController
  before_action :set_user, only: [:home]

  def home
    @theme = 'classic'
    flash[:alert] = 'Your domain has not been unlock yet' if params[:alert] == 'domain'
  end

  private

  def set_user
    if params[:username]
      @user = User.find_by_username params[:username].downcase
    else
      @user = User.find_by_domain UrlHelper.extract(request.host)
    end

    if !@user
      redirect_to not_found_path
    elsif !@user.domain_allowed? && request.domain != ENV['APP_DOMAIN']
      redirect_to profile_url(host: ENV['APP_DOMAIN'], username: @user.username) + '?alert=domain'
    end
  end
end
