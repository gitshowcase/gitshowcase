class InvitationService < ApplicationService
  def initialize(user)
    @user = user
  end

  def accept(inviter_id)
    return false if Invitation.find_by_invitee(@user.username)

    inviter = User.find inviter_id rescue nil

    if inviter
      Invitation.create(inviter_id: inviter.id, invitee: @user.username)
      inviter
    end
  end
end
