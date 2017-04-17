class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    auth = request.env['omniauth.auth']

    @user = User.where(github_uid: auth.uid).first_or_initialize
    github_user_service = GithubUserService.new(@user)
    first_sign_in = false

    if @user.id.present?
      github_user_service.reauth(auth)
    else
      github_user_service.auth(auth)
      github_user_service.sync

      first_sign_in = true

      GithubProjectService.sync_by_user(@user)
      UserSkillService.new(@user).import
      @user.projects.create(homepage: @user.website) if @user.website.present?

      SyncProjectWebsitesJob.perform_later(@user.projects)
      CreateEmailSubscriptionJob.perform_later(@user)
    end

    if @user.persisted?
      sign_in @user, event: :authentication #this will throw if @user is not activated
      redirect_to first_sign_in ? profile_path(username: @user.username) : dashboard_home_path
    else
      session['devise.github_data'] = request.env['omniauth.auth']
      redirect_to '/404'
    end
  end
end
