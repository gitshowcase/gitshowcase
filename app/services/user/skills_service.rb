class User::SkillsService < ApplicationService
  # Constraints
  DEFAULT_SKILL_MASTERY = 3
  MIN_SKILL_MASTERY = 0
  MAX_SKILL_MASTERY = 5

  def initialize(user)
    @user = user
  end

  def import(projects = nil)
    projects = @user.projects if projects.nil?

    skills = @user.skills || {}
    projects.each do |project|
      if project.language.present? && !skills.include?(project.language)
        skills[project.language] = DEFAULT_SKILL_MASTERY
      end
    end

    UserService.new(@user).save(skills: skills)
  end

  # @param skills [Hash]
  def set(skills)
    keys = skills.keys
    skills = convert_from_arrays(skills) if keys.size == 2 && keys.include?(:name) && keys.include?(:mastery)

    parsed = {}

    skills.each do |name, mastery|
      next unless name.present?

      mastery = mastery.to_i
      mastery = MIN_SKILL_MASTERY if mastery < MIN_SKILL_MASTERY
      mastery = MAX_SKILL_MASTERY if mastery > MAX_SKILL_MASTERY

      parsed[name] = mastery
    end

    @user.skills = parsed
  end

  protected

  def convert_from_arrays(params)
    skills = {}

    for i in 0..params[:name].size
      name = params[:name][i]
      mastery = params[:mastery][i]
      skills[name] = mastery
    end

    skills
  end
end
