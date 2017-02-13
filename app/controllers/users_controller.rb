class UsersController < DashboardController
  before_action :set_user

  # GET /users
  def index
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

  def destroy
    # Destroy user. This will trigger delete projects on cascade
    current_user.destroy!

    # Sign out and go home
    sign_out
    redirect_to '/'
  end

  # GET /users/socials
  def socials
  end

  # GET /users/skills
  def skills
  end

  # GET /users/settings
  def settings
  end

  # GET /users/sync
  def sync
    if @user.sync_profile
      redirect_to users_url, notice: 'Your profile was successfully synced.'
    else
      render :index
    end
  end

  # GET /users/sync_projects
  def sync_projects
    results = @user.sync_projects_skills
    redirect_to "/#{current_user.username}", notice: "#{results.length} new projects created."
  end

  private

  def set_user
    # @type [User]
    user = current_user
    @user = user
  end

  def user_params
    params.require(:user).permit(:name, :avatar, :cover, :bio, :role, :location, :company, :company_website, :website,
                                 :hireable, User::SOCIALS)
  end
end
