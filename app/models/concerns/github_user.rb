module GithubUser
  extend ActiveSupport::Concern

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

  def sync_profile
    github_user = client.user

    self.name = github_user.name
    self.username = github_user.login
    self.avatar = github_user.avatar_url
    self.hireable = github_user.hireable
    self.company = github_user.company
    self.company_website = company if company.start_with? '@'

    self.website = github_user.blog if github_user.blog.present?
    self.location = github_user.location if github_user.location.present?
    self.email = github_user.email if github_user.email.present?
    self.bio = github_user.bio if github_user.bio.present?

    save!
  end

  def client
    @client ||= Octokit::Client.new(access_token: github_token)
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
end
