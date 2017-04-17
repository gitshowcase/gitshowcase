class ProfileController < ApplicationController
  before_action :set_user, only: [:home]

  def home
    @theme = 'classic'
  end

  private

  def set_user
    if params[:username]
      @user = User.find_by_username params[:username].downcase
    else
      user = User.find_by_domain UrlHelper.extract(request.host)
      @user = user if user&.domain_allowed?
    end

    unless @user.present?
      redirect_to not_found_path
    end
  end
end
