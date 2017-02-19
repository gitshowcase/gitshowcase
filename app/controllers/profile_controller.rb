class ProfileController < ApplicationController
  before_action :set_user, only: [:show]

  def show
  end

  private

  def set_user
    if params[:username]
      @user = User.find_by_username params[:username].downcase
    else
      @user = User.find_by_domain request.domain
    end

    redirect_to '/404' unless @user.present?
  end
end
