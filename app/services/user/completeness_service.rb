class User::CompletenessService < ApplicationService
  # Constraints
  FIELDS = {
      name: :name,
      bio: :bio,
      role: :role,
      location: :location,
      skills: :skills,
      website: :homepage,
      domain: :homepage,
      socials: :socials,
      projects: :projects
  }

  METRICS = FIELDS.values.uniq

  MAX = 10

  LEVELS = {
      weak: 0,
      medium: 5,
      strong: 8,
      very_strong: 9
  }

  def initialize(user)
    @user = user

    @user.completeness_details ||= {}

    completeness_details ||= {}
    METRICS.each do |metric|
      metric = metric.to_s
      value = @user.completeness_details.key?(metric) ? @user.completeness_details[metric] : 0
      completeness_details[metric] = value
    end

    @user.completeness_details = completeness_details
  end

  def set(field, value)
    field = field.to_sym

    field = :socials if User::SOCIALS.key?(field)
    return unless FIELDS.key? field

    score = send(field, value)
    score = score ? MAX : 0 unless score.is_a? Numeric
    score = [score, MAX].min

    metric = FIELDS[field].to_s
    current = @user.completeness_details[metric]

    if score != current
      @user.completeness_details[metric] = score
      @user.completeness = total
    end

    @user.completeness
  end

  def reset
    set(:name, @user.name)
    set(:bio, @user.bio)
    set(:role, @user.role)
    set(:location, @user.location)
    set(:skills, @user.skills)
    set(:domain, @user.domain)
    set(:website, @user.website)
    set(:socials, @user.socials)
    set(:projects, @user.projects.count)
    @user.save
  end

  def reset_projects
    set(:projects, @user.projects.count)
    @user.save
  end

  def self.level(value)
    value ||= 0

    LEVELS.reverse_each do |name, base|
      return name if value >= base
    end
  end

  protected

  def name(name)
    name.present?
  end

  def bio(bio)
    bio.present?
  end

  def role(role)
    role.present? && role != 'Jedi Developer'
  end

  def location(location)
    location.present?
  end

  def skills(skills)
    skills_value = (skills || {}).size * 3
    (skills || {}).values.uniq == [User::SkillsService::DEFAULT_SKILL_MASTERY] ? 0 : skills_value
  end

  def domain(domain)
    homepage(domain, @user.website)
  end

  def website(website)
    homepage(@user.domain, website)
  end

  def homepage(domain, website)
    domain.present? || website.present?
  end

  def socials(_)
    (@user.socials.size - 1) * 5
  end

  def projects(count)
    count * 3.5
  end

  def total
    total = 0
    METRICS.each { |metric| total += @user.completeness_details[metric.to_s] }

    (total.to_f / METRICS.size).round(1)
  end
end
