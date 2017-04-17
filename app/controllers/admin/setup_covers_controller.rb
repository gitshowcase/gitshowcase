class Admin::SetupCoversController < AdminController
  before_action :set_admin_setup_cover, only: [:destroy]

  # GET /admin/setup_covers
  def index
    @setup_covers = SetupCover.all
  end

  # POST /admin/setup_covers
  def create
    url = HTTP.get('https://source.unsplash.com/random/1080x720')[:Location].gsub(/\?.*/, '')
    SetupCover.create(url: url)
    redirect_to admin_setup_covers_url
  end

  # DELETE /admin/setup_covers/1
  def destroy
    @admin_setup_cover.destroy
    redirect_to admin_setup_covers_url
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_admin_setup_cover
    @admin_setup_cover = SetupCover.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def admin_setup_cover_params
    params.require(:admin_setup_cover).permit(:url)
  end
end
