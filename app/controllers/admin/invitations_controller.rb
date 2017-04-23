class Admin::InvitationsController < AdminController
  # GET /admin/invitations
  def index
    @invitations = Invitation.order('id DESC').paginate(page: params[:page], per_page: 20)
  end
end
