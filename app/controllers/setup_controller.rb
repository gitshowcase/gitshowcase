class SetupController < ApplicationController
  # GET /sync
  def sync
  end

  # GET /setup/cover
  def cover
    @title = 'Choose your cover image'
    @description = 'Stay calm, you can still change it later :)'
    @next = setup_socials_path

    @covers = SetupCover.order('RANDOM()').limit(12)
  end

  def update_cover

  end

  # GET /setup/socials
  def socials
    @title = 'Configure your social networks'
    @description = 'Where else can you be found online?'
    @next = setup_skills_path
  end

  def update_socials

  end

  # GET /setup/skills
  def  skills
    @title = 'What are you good at?'
    @description = 'Programming languages, frameworks, hobbies...'
    @next = profile_path(username: current_user.username)
  end

  def update_skills

  end

  # GET /setup/theme
  def theme
    @title = 'Which theme do you like more?'
    @description = 'You can acquire new themes later in our store'
  end

  def update_theme

  end
end
