class UsersController < DashboardController
  before_action :set_user

  # GET /users
  # GET /users.json
  def index
  end

  # GET /users/socials
  # GET /users/socials.json
  def socials
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if @user.update(user_params)
      redirect_to '/', notice: 'Your profile was successfully updated.'
    else
      render :index
    end
  end

  # GET /users/sync
  # GET /users/sync.json
  def sync
    if @user.sync
      redirect_to users_url, notice: 'Your profile was successfully synced.'
    else
      render :index
    end
  end

  # GET /users/sync_projects
  # GET /users/sync_projects.json
  def sync_projects
    results = @user.sync_skills_projects
    redirect_to projects_url, notice: "#{results.length} new projects created."
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = current_user
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :avatar, :cover, :bio, :role, :location, :company, :company_website, :website,
                                 :resume, :hireable, :show_email, User::SOCIALS)
  end
end
