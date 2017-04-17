class GithubUserService < ApplicationService
  # Constraints
  SYNC_FIELDS = %w(name username avatar website location display_email bio company company_website hireable)

  def initialize(user)
    @user = user
  end

  # @param auth [OmniAuth::Strategy]
  def auth(auth)
    @user.email = auth.info.email
    @user.password = Devise.friendly_token[0, 20]
    @user.github_uid = auth.uid
    @user.github_token = auth.credentials.token
    @user.role = 'Jedi Developer'
    @user.save
  end

  # @param auth [OmniAuth::Strategy]
  def reauth(auth)
    @user.update_attribute(:github_token, auth.credentials.token)
  end

  def sync
    raise "User ##{@user.id} does not have github properties" unless @user.github_uid.present? && @user.github_token.present?

    SYNC_FIELDS.each do |field|
      field = field.to_s
      send("sync_#{field}") if SYNC_FIELDS.include? field
    end

    @user.save!
  end

  protected

  def client
    @client ||= Octokit::Client.new(access_token: @user.github_token)
  end

  def client_user
    @client_user ||= client.user
  end

  def sync_name
    @user.name = client_user.name
  end

  def sync_username
    @user.username = client_user.login.downcase
  end

  def sync_avatar
    avatar = client_user.avatar_url

    # Add suggested size to avoid oversized preview images from GitHub
    if avatar and avatar.start_with?('https://avatars.githubusercontent.com') and !avatar.include?('s=')
      avatar << (avatar.include?('?') ? '&' : '?') + 's=400'
    end

    @user.avatar = avatar
  end

  def sync_hireable
    @user.hireable = client_user.hireable
  end

  def sync_company
    @user.company = client_user.company
  end

  def sync_company_website
    company = client_user.company
    if company.present?
      @user.company_website = company.start_with?('@') ? ('https://github.com/' + company[1..-1]) : company
    end
  end

  def sync_website
    @user.website = client_user.blog if client_user.blog.present?
  end

  def sync_location
    @user.location = client_user.location if client_user.location.present?
  end

  def sync_display_email
    @user.display_email = client_user.email if client_user.email.present?
  end

  def sync_bio
    @user.bio = client_user.bio if client_user.bio.present?
  end
end
