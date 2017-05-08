class GithubProjectService < ApplicationService
  def initialize(project)
    @project = project
  end

  def sync(data = nil)
    raise "Project ##{@project.id} - #{@project.title} does not have a repository to sync" unless @project.repository.present?

    repository = UrlHelper.extract(@project.repository, 'github.com/')
    data = client.repository(repository) if data.nil?

    @project.title = data.name.titleize
    @project.homepage = data.homepage
    @project.repository = data.full_name
    @project.description = data.description
    @project.language = data.language
    @project.fork = data.fork
    @project.stars = data.stargazers_count
    @project.forks = data.forks_count
    @project.syncing = @project.homepage.present? ? true : false
    @project.save
  end

  # @param projects [Project[]]
  def self.sync(projects = nil)
    projects = Project.all if projects.nil?
    projects.each { |project| self.new(project).sync }
  end

  # @param user [User]
  def self.sync_by_user(user)
    repositories = client(user).repositories
    created = []

    User.transaction do
      repositories.each do |repository|
        project = Project.find_or_initialize_by(user_id: user.id, repository: repository.full_name)
        created << project unless project.id
        self.new(project).sync(repository)
      end
    end

    created
  end

  def sync_forks_stars
    # TODO
  end

  protected

  def client(user = nil)
    user = @project.user if user.nil?
    @client ||= self.class.client(user)
  end

  def self.client(user)
    Octokit::Client.new(access_token: user.github_token)
  end
end
