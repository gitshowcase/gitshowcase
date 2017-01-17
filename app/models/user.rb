class User < ApplicationRecord
  has_many :projects
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:github]

  SOCIALS_NETWORKING = {
      linkedin: 'linkedin.com/in',
      angellist: 'angel.co',
      twitter: 'twitter.com',
      facebook: 'facebook.com',
      google_plus: 'plus.google.com'
  }

  SOCIALS_DEVELOPMENT = {
      stack_overflow: 'stackoverflow.com/users',
      codepen: 'codepen.io',
      jsfiddle: 'jsfiddle.net'
  }

  SOCIALS_WRITING = {
      medium: 'medium.com',
      blog: ''
  }

  SOCIALS_DESIGN = {
      behance: 'behance.net',
      dribbble: 'dribbble.com',
      pinterest: 'pinterest.com'
  }

  GROUPED_SOCIALS = [
      [:networking, SOCIALS_NETWORKING],
      [:writing, SOCIALS_WRITING],
      [:development, SOCIALS_DEVELOPMENT],
      [:design, SOCIALS_DESIGN]
  ]

  HASH_SOCIALS = GROUPED_SOCIALS.flat_map { |group| group[1].map { |social| [social[0], social[1]] } }.to_h
  SOCIALS = HASH_SOCIALS.flat_map { |social, _| social }

  def socials
    result = {}
    result['github'] = self.username

    User::SOCIALS.each do |social|
      result[social] = self[social] unless self[social].to_s.empty?
    end

    result
  end

  def self.from_omniauth(auth)
    user = where(github_uid: auth.uid).first

    if user
      user.github_token = auth.credentials.token
      user.save
    else
      user = User.new
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.github_uid = auth.uid
      user.github_token = auth.credentials.token
      user.role = 'Jedi Developer'

      user.sync_profile
    end

    user
  end

  def sync
    sync_profile
    sync_skills_projects
  end

  def sync_profile
    user = client.user

    self.avatar = user.avatar_url
    self.username = user.login.to_s.downcase
    self.name = user.name
    self.website = user.blog if user.blog.present?
    self.location = user.location if user.location.present?
    self.email = user.email if user.email.present?
    self.hireable = user.hireable
    self.bio = user.bio if user.bio.present?

    self.company = user.company
    self.company_website = 'https://github.com/' + self.company[1..-1] if self.company.present? and self.company[0] == '@'

    save!
  end

  def sync_skills_projects
    result = []

    client.repositories.each do |repository|
      project = projects.where(repository: repository.full_name).first

      unless project
        project = projects.new(repository: repository.full_name)
        project.sync(repository)

        result.push project

        if project.language.present?
          self.skills = {} unless self.skills
          self.skills[project.language] = 3 unless self.skills[project.language]
        end
      end
    end

    save!

    result
  end

  def linkedin=(val)
    set_social(:linkedin, val)
  end

  def angellist=(val)
    set_social(:angellist, val)
  end

  def facebook=(val)
    set_social(:facebook, val)
  end

  def twitter=(val)
    set_social(:twitter, val)
  end

  def google_plus=(val)
    set_social(:google_plus, val)
  end

  def medium=(val)
    set_social(:medium, val)
  end

  def stack_overflow=(val)
    set_social(:stack_overflow, val)
  end

  def codepen=(val)
    set_social(:codepen, val)
  end

  def jsfiddle=(val)
    set_social(:jsfiddle, val)
  end

  def behance=(val)
    set_social(:behance, val)
  end

  def dribbble=(val)
    set_social(:dribbble, val)
  end

  def pinterest=(val)
    set_social(:pinterest, val)
  end

  def social(key)
    "https://#{HASH_SOCIALS[key]}/#{self[key]}"
  end

  def self.social(key, value)
    "https://#{HASH_SOCIALS[key]}/#{value}"
  end

  private

  def client
    @client ||= Octokit::Client.new(:access_token => self.github_token)
  end

  def set_social(key, value)
    pre = HASH_SOCIALS[key]
    self[key] = value.sub(/^https?\:\/\//, '').sub(/^www./,'').sub(pre, '')
  end
end
