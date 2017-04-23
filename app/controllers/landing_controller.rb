class LandingController < ApplicationController
  def home
    @project_count = Project.count

    inviter_id = session[:inviter_id]
    @inviter = User.find(inviter_id) rescue nil if inviter_id
  end

  def invitation
    @user = User.find_by_username params[:username]
    session[:inviter_id] = @user ? @user.id : nil
    redirect_to root_path
  end
end
