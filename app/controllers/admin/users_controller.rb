class Admin::UsersController < AdminController
  before_action :set_user, only: [:show]

  # GET /admin/users
  def index
    @users = User.order('id DESC').paginate(page: params[:page], per_page: 12)
  end

  # GET /admin/users/:id
  def show
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
