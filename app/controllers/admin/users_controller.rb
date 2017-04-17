class Admin::UsersController < AdminController
  # GET /admin/users
  def index
    @users = User.order('id DESC').paginate(page: params[:page], per_page: 3)
  end
end
