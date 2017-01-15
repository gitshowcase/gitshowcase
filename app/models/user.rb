class User < ApplicationRecord
  SOCIALS = %w(angellist twitter linkedin facebook medium stack_overflow blog).freeze

  has_many :projects

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:github]

  def socials
    result = {}
    result['github'] = "https://github.com/#{self.username}"

    User::SOCIALS.each do |social|
      result[social] = self[social] unless self[social].to_s.empty?
    end

    result
  end

  def self.from_omniauth(auth)
    user = where(github_uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.github_uid = auth.uid
      user.github_token = auth.credentials.token
      user.role = 'Jedi Developer'
    end

    user.sync
  end

  def sync
    fetch_repositories(true)

    sync_profile
    sync_skills
    sync_projects

    self
  end

  private

  def client
    @client ||= Octokit::Client.new(:access_token => self.github_token)
  end

  def fetch_repositories(force = false)
    @fetched_repositories = client.repositories if force or @fetched_repositories

    @fetched_repositories
  end

  def sync_profile
    user = client.user

    self.avatar = user.avatar_url
    self.username = user.login
    self.name = user.name
    self.website = user.blog
    self.location = user.location
    self.email = user.email
    self.hireable = user.hireable
    self.bio = user.bio

    self.company = user.company
    self.company_website = 'https://github.com/' + self.company[1..-1] if self.company[0] == '@'

    self.save
  end

  def sync_skills
    self.skills = {} unless self.skills

    fetch_repositories.map do |repository|
      language = repository.language
      self.skills[language] = 3 unless self.skills[language]
    end
  end

  def sync_projects
    fetch_repositories.map do |repository|
      project = projects.where(url: repository.html_url).first_or_create
      project.sync_repository(repository)
    end
  end
end
