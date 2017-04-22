class InvitationService < ApplicationService
  def initialize(user)
    @user = user
  end

  def accept(inviter_id)
    return false if Invitation.find_by_invitee(@user.username)

    host = User.find inviter_id rescue nil
    if host
      Invitation.create(inviter_id: host.id, invitee: @user.username)
      return true
    end

    false
  end
end
