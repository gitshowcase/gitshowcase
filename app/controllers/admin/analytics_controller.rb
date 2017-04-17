class Admin::AnalyticsController < AdminController
  # GET /admin/analytics
  def home
    @projects_count = Project.count
    @users_count = User.count
  end
end
