class LandingController < ApplicationController
  def home
    @project_count = Project.count;
  end
end
