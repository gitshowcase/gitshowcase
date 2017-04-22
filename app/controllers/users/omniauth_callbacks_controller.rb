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

      if session.key?(:inviter)
        InvitationService.new(@user).accept(session[:inviter])
        PlanService.new(@user).reward_domain
      end

      GithubProjectService.sync_by_user(@user)
      UserSkillService.new(@user).import
      @user.projects.create(homepage: @user.website) if @user.website.present?

      SyncUserProjectWebsitesJob.perform_later(@user)
      CreateEmailSubscriptionJob.perform_later(@user)
    end

    if @user.persisted?
      sign_in @user, event: :authentication #this will throw if @user is not activated
      path = first_sign_in ? profile_path(username: @user.username) : root_path
      redirect_to "#{path}?utm_source=github&utm_medium=authentication"
    else
      session['devise.github_data'] = request.env['omniauth.auth']
      redirect_to '/404'
    end
  end
end
