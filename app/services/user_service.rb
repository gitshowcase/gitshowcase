class UserService < ApplicationService
  def initialize(user)
    @user = user
  end

  def set(hash)
    hash.each { |field, value| set_field(field, value) }
  end

  def save(hash)
    set(hash)
    @user.save!
  end

  protected

  def set_field(field, value)
    if field == :skills
      value = skills.set(value)
    elsif field == :location
      location.set(value)
    elsif field == :ip
      return
    else
      @user[field] = value
    end

    # Update completeness
    completeness.set(field, value)
  end

  def location
    @location ||= User::LocationService.new @user
  end

  def skills
    @skills ||= User::SkillsService.new @user
  end

  def completeness
    @completeness ||= User::CompletenessService.new @user
  end
end
