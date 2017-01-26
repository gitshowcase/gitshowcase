class UsersController < DashboardController
  before_action :set_user

  # GET /users
  def index
  end

  # GET /users/socials
  def socials
  end

  # GET /users/skills
  def skills
  end

  # PATCH/PUT /users/1
  def update
    skills = params[:user][:skills]
    if (!skills and @user.update(user_params)) or (skills and @user.update_skills(skills))
      redirect_to '/', notice: 'Your profile was successfully updated.'
    else
      render :index
    end
  end

  # GET /users/sync
  def sync
    if @user.sync
      redirect_to users_url, notice: 'Your profile was successfully synced.'
    else
      render :index
    end
  end

  # GET /users/sync_projects
  def sync_projects
    results = @user.sync_skills_projects
    redirect_to "/#{current_user.username}", notice: "#{results.length} new projects created."
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = current_user
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :avatar, :cover, :bio, :role, :location, :company, :company_website, :website,
                                 :hireable, User::SOCIALS)
  end
end
