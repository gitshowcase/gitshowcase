class SetupController < ApplicationController
  before_action :set_user

  # GET /setup
  def profile
    @title = "Hey @#{@user.username}"
    @description = 'We got some info from your GitHub. How do you like it?'
  end

  # PUT/PATCH /setup
  def update_profile
    values = user_params(:name, :bio, :role, :location, :company)

    # location = LocationService.new.get(params[:location])
    # values[:city_id] = location[:city_id]
    # values[:country_id] = location[:country_id] if location[:country_id]
    # values[:location] = location[:location]

    service.save(values)
    redirect_to setup_cover_path
  end

  # GET /setup/cover
  def cover
    @title = 'Choose your cover image'
    @description = 'Stay calm, you can still change it later :)'

    @covers = SetupCover.order('RANDOM()').limit(8)
  end

  # PUT/PATCH /setup/cover
  def update_cover
    service.save(cover: params[:cover])
    redirect_to setup_socials_url
  end

  # GET /setup/socials
  def socials
    @title = 'Configure your social networks'
    @description = 'Where else can you be found online?'
  end

  # PUT/PATCH /setup/socials
  def update_socials
    service.save(user_params(User::SOCIALS.keys))
    redirect_to setup_skills_url
  end

  # GET /setup/skills
  def skills
    @title = 'What are you good at?'
    @description = 'Programming languages, frameworks, hobbies...'
  end

  # PUT/PATCH /setup/skills
  def update_skills
    hash = {name: params[:name], mastery: params[:mastery]}
    service.save(skills: hash)
    redirect_to setup_projects_url
  end

  # GET /setup/projects
  def projects
    @title = 'Projects'
    @description = 'What do you wanna show off?'

    @personal_projects = []
    @forked_projects = []

    @user.projects.each do |project|
      (project.fork ? @forked_projects : @personal_projects) << project
    end
  end

  # GET /setup/theme
  def theme
    @title = 'Which theme do you like more?'
    @description = 'You can acquire new themes later in our store'
  end

  # PUT/PATCH /setup/theme
  def update_theme

  end

  private

  def set_user
    # @type [User]
    user = current_user
    @user = user
  end

  def user_params(*fields)
    params.require(:user).permit(fields)
  end

  def service
    @service ||= UserService.new(@user)
  end
end
