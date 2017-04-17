class UserSkillService < ApplicationService
  # Constraints
  DEFAULT_SKILL_MASTERY = 3
  MIN_SKILL_MASTERY = 0
  MAX_SKILL_MASTERY = 5

  def initialize(user)
    @user = user
  end

  def import(projects = nil)
    projects = @user.projects if projects.nil?

    @user.skills ||= {}
    projects.each do |project|
      if project.language.present? && !@user.skills.include?(project.language)
        @user.skills[project.language] = DEFAULT_SKILL_MASTERY
      end
    end

    @user.save!
  end

  def update(skills)
    parsed = {}

    skills.each do |name, mastery|
      next unless name.present?

      mastery = mastery.to_i
      mastery = MIN_SKILL_MASTERY if mastery < MIN_SKILL_MASTERY
      mastery = MAX_SKILL_MASTERY if mastery > MAX_SKILL_MASTERY

      parsed[name] = mastery
    end

    @user.update!({skills: parsed})
  end
end
