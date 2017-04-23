class Admin::PlansController < AdminController
  # GET /admin/plans
  def index
    @plans = Plan.order('name')
  end

  # GET /admin/plans/1
  def show
    @plan = Plan.find(params[:id])
    @users = @plan.users.order('created_at DESC').paginate(page: params[:page], per_page: 20)
  end
end
