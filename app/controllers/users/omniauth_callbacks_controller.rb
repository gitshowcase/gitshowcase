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

      if session.key?(:inviter_id)
        inviter = InvitationService.new(@user).accept(session[:inviter_id])
        PlanService.new(inviter).reward_domain if inviter
      end

      GithubProjectService.sync_by_user(@user)
      User::SkillsService.new(@user).import

      @user.projects.create(homepage: @user.website) if @user.website.present?
      User::CompletenessService.new(@user).reset_projects

      SyncUserProjectWebsitesJob.perform_later(@user)
      CreateEmailSubscriptionJob.perform_later(@user)
    end

    if @user.persisted?
      sign_in @user, event: :authentication #this will throw if @user is not activated
      path = first_sign_in ? setup_profile_url : root_url
      redirect_to "#{path}?utm_source=github&utm_medium=authentication"
    else
      session['devise.github_data'] = request.env['omniauth.auth']
      redirect_to '/404'
    end
  end
end
