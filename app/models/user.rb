class User < ApplicationRecord
  # Concerns
  include SocialNetworks

  # Relationships
  has_many :projects
  has_many :invitations, foreign_key: 'inviter_id'
  belongs_to :plan, optional: true

  # Authentication
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:github]

  # Urls
  url :website
  url :company_website

  # Methods
  def display_name
    name.present? ? name : username
  end

  def first_name
    display_name.split(' ')[0]
  end

  def domain_allowed?
    admin.present? || plan&.domain
  end

  def url
    return UrlHelper.url(domain) if domain && domain_allowed?
    Rails.application.routes.url_helpers.profile_url(host: ENV['APP_DOMAIN'], username: username)
  end

  def metrics
    skills_value = (skills || {}).size * 3
    skills_value = 0 if (skills || {}).values.uniq == [UserSkillService::DEFAULT_SKILL_MASTERY]

    {
        name: name.present?,
        cover: cover.present?,
        bio: bio.present?,
        role: role.present? && role != 'Jedi Developer',
        location: location.present?,
        skills: skills_value,
        website: (domain.present? && domain_allowed?) || website.present?,
        socials: (socials.size - 1) * 5,
        projects: projects.count * 3
    }
  end

  def score
    total = 0

    metrics.each do |_, value|
      value = value ? 10 : 0 unless value.is_a? Numeric
      total += [value, 10].min
    end

    total.to_f / metrics.size
  end
end
