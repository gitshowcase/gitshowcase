class PlanService < ApplicationService
  # Constraints
  INVITATIONS_REQUIREMENT = 5
  INVITATION_PLAN = 'invitation'

  def initialize(user)
    @user = user
  end

  def reward_domain
    return false unless @user.invitations.count >= INVITATIONS_REQUIREMENT

    plan = Plan.find_by_slug(INVITATION_PLAN)
    plan = Plan.create(name: 'Invitation Reward', slug: INVITATION_PLAN, domain: true) unless plan

    @user.update(plan_id: plan.id)
  end
end