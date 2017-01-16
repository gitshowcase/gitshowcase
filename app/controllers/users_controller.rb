class UsersController < DashboardController
  before_action :set_user, only: [:index, :update]

  def index
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to '/', notice: 'Your profile was successfully updated.' }
        format.json { render :index, status: :ok }
      else
        format.html { render :index }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = current_user
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :avatar, :cover, :bio, :role, :location, :company, :company_website, :website,
                                 :resume, :hireable, :show_email)
  end
end
