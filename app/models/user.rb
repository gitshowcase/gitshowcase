class User < ApplicationRecord
  # Concerns
  include GithubUser
  include SocialNetworks

  # Relationships
  has_many :projects

  # Authentication
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:github]

  # Urls
  url :website
  url :company_website

  # Constraints
  DEFAULT_SKILL_MASTERY = 3

  # Methods
  def display_name
    name || username
  end

  def first_name
    display_name.split(' ')[0]
  end

  def sync_projects_skills
    projects = sync_projects
    add_skills_by_projects projects

    projects
  end

  def add_skills_by_projects(projects)
    projects.each { |project| skills[project.language] = DEFAULT_SKILL_MASTERY if project.language.present? and !skills[project .language] }
    save!
  end

  def update_skills(skills)
    parsed = {}

    skills.each do |name, mastery|
      mastery = mastery.to_i
      mastery = 0 if mastery < 0
      mastery = 5 if mastery > 5

      parsed[name] = mastery
    end

    update!({skills: parsed})
  end
end
