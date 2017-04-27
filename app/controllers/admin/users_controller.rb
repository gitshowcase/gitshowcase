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
    param = params[:id]
    is_number = true if Float(param) rescue false
    @user = is_number ? User.find(param) : User.find_by_username(param)
  end
end
