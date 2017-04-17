class Dashboard::UsersController < DashboardController
  before_action :set_user

  # GET /dashboard
  def home
    @socials = @user.socials
    @projects = @user.projects
  end

  # GET /dashboard/domain
  def domain
  end

  # PUT /dashboard/domain
  def update_domain
    return redirect_to root_path unless @user.domain_allowed?

    old_domain = @user.domain
    new_domain = user_params(:domain)[:domain]

    if old_domain != new_domain
      begin
        DomainService.new(new_domain).add if new_domain.present?
      rescue Exception => e
        return redirect_to dashboard_domain_path, alert: e.message
      end

      RemoveDomainJob.perform_later(old_domain) if old_domain.present?
      @user.update(domain: new_domain)
    end

    redirect_to dashboard_home_url, notice: 'Domain updated :)'
  end

  # GET /dashboard/profile
  def profile
  end

  # PUT /dashboard/profile
  def update_profile
    @user.update(user_params(:name, :avatar, :cover, :bio, :role, :location, :display_email, :company, :company_website, :website, :hireable))
    redirect_to dashboard_home_url, notice: 'Profile updated :)'
  end

  # GET /dashboard/socials
  def socials
  end

  # PUT /dashboard/socials
  def update_socials
    @user.update(user_params(User::SOCIALS.keys))
    redirect_to dashboard_home_url, notice: 'Socials updated :)'
  end

  # GET /dashboard/skills
  def skills
  end

  # PUT /dashboard/skills
  def update_skills
    skills = {}

    for i in 0..params[:name].size
      name = params[:name][i]
      mastery = params[:mastery][i]
      skills[name] = mastery
    end

    UserSkillService.new(@user).update(skills)
    redirect_to dashboard_home_url, notice: 'Skills updated :)'
  end

  # GET /dashboard/billing
  def billing
  end

  # GET /dashboard/settings
  def settings
  end

  # GET /dashboard/sync_profile
  def sync_profile
    GithubProjectService.sync_by_user(@user)
    redirect_to dashboard_profile_url, notice: 'Profile synced :)'
  end

  # DELETE /users/1
  def destroy
    # Remove domain and delete email subscription
    RemoveDomainJob.perform_later(@user.domain) if @user.domain.present?
    DeleteEmailSubscriptionJob.perform_later(@user.email)

    # Destroy user. This will trigger delete projects on cascade
    @user.destroy!

    # Sign out
    sign_out

    # Redirect to root
    redirect_to '/', notice: 'Feel free to come back again another day :)'
  end

  private

  def set_user
    # @type [User]
    user = current_user
    @user = user
  end

  def user_params(*fields)
    params.require(:user).permit(fields)
  end
end
