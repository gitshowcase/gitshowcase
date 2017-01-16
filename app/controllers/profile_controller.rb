class ProfileController < ApplicationController
  before_action :set_user, only: [:show]

  def show
  end

  private

  def set_user
    if !params[:username] and current_user
      @user = current_user
    else
      @user = User.find_by_username!(params[:username].downcase)
    end
  end
end
