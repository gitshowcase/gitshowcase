class User::LocationService < ApplicationService
  def initialize(user)
    @user = user
  end

  def set(location)
    # TODO
    # values = LocationService.new.get(full_name)
    @user.location = location
  end
end
