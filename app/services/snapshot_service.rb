class SnapshotService < ApplicationService
  # Constraints
  TYPE_TOTAL = :total
  TYPE_DAILY = :daily

  GENERAL = [:count_users, :count_projects, :count_domains]

  USER_COMPLETENESS = [:total_user_completeness,
                       :count_user_weak_completeness,
                       :count_user_medium_completeness,
                       :count_user_strong_completeness,
                       :count_user_very_strong_completeness]

  INVITATION = [:count_invitations]

  INVITATION_FUNNEL = [:count_zero_invitations,
                       :count_one_invitations,
                       :count_two_invitations,
                       :count_three_invitations,
                       :count_four_invitations,
                       :count_five_invitations,
                       :count_six_more_invitations,
                       :count_invitation_rewards]

  def initialize(date = nil)
    date ||= Date.today
    @date = date
  end

  def snapshot
    Snapshot.new({date: @date}.merge(all))
  end

  def create
    snapshot.save
  end

  def fields(fields, type = nil)
    values = fields.map do |field|
      name = field.to_s
      type ||= name.starts_with?('daily_') ? TYPE_DAILY : TYPE_TOTAL

      [field, send(name.sub('daily_', ''), type)]
    end

    Hash[values]
  end

  def all
    [
        general(TYPE_TOTAL),
        user_completeness(TYPE_TOTAL),
        invitation(TYPE_TOTAL),
        invitation_funnel,
        general(TYPE_DAILY),
        user_completeness(TYPE_DAILY),
        invitation(TYPE_DAILY)
    ].reduce(:merge)
  end

  # General

  def general(type = TYPE_TOTAL)
    execute(type, GENERAL)
  end

  def count_users(type = TYPE_TOTAL)
    query(User, type).count
  end

  def count_projects(type = TYPE_TOTAL)
    query(Project, type).count
  end

  def count_domains(type = TYPE_TOTAL)
    query(User, type).where("domain is not null and domain != ''").count
  end

  # User Completeness

  def user_completeness(type = TYPE_TOTAL)
    execute(type, USER_COMPLETENESS)
  end

  def total_user_completeness(type = TYPE_TOTAL)
    query(User, type).sum(:completeness)
  end

  def count_user_weak_completeness(type = TYPE_TOTAL)
    user_completeness_count(:weak, type)
  end

  def count_user_medium_completeness(type = TYPE_TOTAL)
    user_completeness_count(:medium, type)
  end

  def count_user_strong_completeness(type = TYPE_TOTAL)
    user_completeness_count(:strong, type)
  end

  def count_user_very_strong_completeness(type = TYPE_TOTAL)
    user_completeness_count(:very_strong, type)
  end

  # Invitation

  def invitation(type = TYPE_TOTAL)
    execute(type, INVITATION)
  end

  def count_invitations(type = TYPE_TOTAL)
    query(Invitation, type).count
  end

  # Invitation Funnel

  def invitation_funnel(type = TYPE_TOTAL)
    execute(type, INVITATION_FUNNEL)
  end

  def count_invitation_rewards(type = TYPE_TOTAL)
    query(User, type).where(plan_id: invitation_reward_id).count
  end

  def count_zero_invitations(type = TYPE_TOTAL)
    others = invitation_counts(type).map { |key, value| key > 6 ? 0 : value }.sum
    count_domains(type) - others
  end

  def count_one_invitations(type = TYPE_TOTAL)
    invitation_counts(type)[1] || 0
  end

  def count_two_invitations(type = TYPE_TOTAL)
    invitation_counts(type)[2] || 0
  end

  def count_three_invitations(type = TYPE_TOTAL)
    invitation_counts(type)[3] || 0
  end

  def count_four_invitations(type = TYPE_TOTAL)
    invitation_counts(type)[4] || 0
  end

  def count_five_invitations(type = TYPE_TOTAL)
    invitation_counts(type)[5] || 0
  end

  def count_six_more_invitations(type = TYPE_TOTAL)
    invitation_counts(type)[6] || 0
  end

  protected

  def prefix(type, hash)
    type == TYPE_DAILY ? daily(hash) : hash
  end

  def daily(hash)
    Hash[hash.map { |key, value| ["daily_#{key}".to_sym, value] }]
  end

  def execute(type, fields)
    values = fields.map { |field| [field, send(field, type)] }
    prefix(type, Hash[values])
  end

  def invitation_reward_id
    @invitation_reward_id ||= Plan.find_by_slug(PlanService::INVITATION_PLAN).id
  end

  def query(model, type)
    @queries ||= {}
    @queries["#{model.name}-#{type}"] ||= model.where("DATE(#{model.table_name}.created_at) #{type == TYPE_TOTAL ? '<=' : '='} ?", @date)
  end

  def user_completeness_count(level, type)
    target = User::CompletenessService::LEVELS[level]
    level_values = User::CompletenessService::LEVELS.values
    next_level = level_values.at(level_values.find_index(target) + 1)

    user_query = query(User, type).where('completeness >= ?', target)
    user_query = user_query.where('completeness < ?', next_level) unless next_level.nil?
    user_query.count
  end

  def invitation_counts(type)
    return @invitation_counts unless @invitation_counts.nil?

    grouped_invitations = query(Invitation, type).joins(:inviter).select('count(users.id) as invitees').group('users.id').all
    @invitation_counts = Hash[grouped_invitations.group_by(&:invitees).map { |invitations, rows| [invitations, rows.count] }]
    @invitation_counts[6] = @invitation_counts.map { |invitations, count| invitations >= 6 ? count : 0 }.sum

    @invitation_counts
  end
end
