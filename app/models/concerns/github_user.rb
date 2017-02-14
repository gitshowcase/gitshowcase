module GithubUser
  extend ActiveSupport::Concern

  SYNC_FIELDS = %w(name username avatar website location display_email bio company company_website hireable)

  class_methods do
    def github_auth(auth)
      instance = self.new
      instance.email = auth.info.email
      instance.password = Devise.friendly_token[0, 20]
      instance.github_uid = auth.uid
      instance.github_token = auth.credentials.token
      instance.role = 'Jedi Developer'

      instance.sync_profile
      instance
    end

    # This method is used for batch updates after adding a new field or updating the logic
    def sync_profiles(fields = nil, users = User.all)
        users.each { |user| user.sync_profile fields }
    end
  end

  # @param val [String]
  def avatar=(val)
    # Add suggested size to avoid oversized preview images from GitHub
    if val.start_with?('https://avatars.githubusercontent.com') and !val.include?('s=')
      val << (val.include?('?') ? '&' : '?') + 's=400'
    end

    self[:avatar] = val
  end

  # @param val [String]
  def company_website=(val)
    self[:company_website] = val.start_with?('@') ? ('https://github.com/' + val[1..-1]) : val
  end

  # @param val [String]
  def username=(val)
    self[:username] = val.to_s.downcase
  end

  def client
    @client ||= Octokit::Client.new(access_token: github_token)
  end

  def client_user
    @client_user ||= client.user
  end

  def sync_profile(fields = nil)
    fields ||= SYNC_FIELDS
    fields = [fields] if fields.is_a? String

    fields.each do |field|
      field = field.to_s
      send("sync_#{field}") if SYNC_FIELDS.include? field
    end

    save!
  end

  def sync_projects
    projects = Project.sync_by_user(self)

    website_project = sync_website_project
    projects.push website_project if website_project

    projects
  end

  def sync_website_project
    return nil if !website or projects.where(homepage: website).first

    project = projects.new(homepage: website, position: 0)
    project.sync_homepage
    project
  end

  protected

  def sync_name
    self.name = client_user.name
  end

  def sync_username
    self.username = client_user.login
  end

  def sync_avatar
    self.avatar = client_user.avatar_url
  end

  def sync_hireable
    self.hireable = client_user.hireable
  end

  def sync_company
    self.company = client_user.company
  end

  def sync_company_website
    self.company_website = company if company.start_with? '@'
  end

  def sync_website
    self.website = client_user.blog if client_user.blog.present?
  end

  def sync_location
    self.location = client_user.location if client_user.location.present?
  end

  def sync_display_email
    self.display_email = client_user.email if client_user.email.present?
  end

  def sync_bio
    self.bio = client_user.bio if client_user.bio.present?
  end
end
