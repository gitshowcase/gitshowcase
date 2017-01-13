class ProfileController < ApplicationController
  before_action :set_user, only: [:show]

  def show

  end

  private
  def set_user
    @user = params[:user_id] || current_user
  end
end
