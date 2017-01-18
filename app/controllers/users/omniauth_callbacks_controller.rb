class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    auth = request.env['omniauth.auth']

    @user = User.where(github_uid: auth.uid).first
    created = false

    if @user
      created = true
      @user.github_token = auth.credentials.token
      @user.save
    else
      @user = User.create_from_omniauth(auth)
    end

    if @user.persisted?
      sign_in @user, :event => :authentication #this will throw if @user is not activated
      # set_flash_message(:notice, :success, :kind => "Github") if is_navigational_format?
      redirect_to created ? sync_url : users_url
    else
      session['devise.github_data'] = request.env['omniauth.auth']
      redirect_to new_user_registration_url
    end
  end
end
