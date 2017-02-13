module Skilled
  extend ActiveSupport::Concern

  def sync_skills
    if project.language.present?
      self.skills = {} unless self.skills
      self.skills[project.language] = 3 unless self.skills[project.language]
    end
  end
end