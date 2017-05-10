class Admin::AnalyticsController < AdminController
  # GET /admin/analytics
  def index

  end

  # GET /admin
  def home
    @totals = [snapshot.general, snapshot.invitation, snapshot.invitation_funnel].reduce(:merge)
    @users = User.order('id DESC').limit(6)
    @invitations = Invitation.order('id DESC').limit(4)
  end

  # GET /admin/analytics/growth
  def growth
    history([:count_users, :count_projects])
  end

  # GET /admin/analytics/user_completeness
  def user_completeness
    fields = [
        :count_users,
        :total_user_completeness,
        :count_user_weak_completeness,
        :count_user_medium_completeness,
        :count_user_strong_completeness,
        :count_user_very_strong_completeness
    ]

    history(fields)
  end

  # GET /admin/analytics/invitation_funnel
  def invitation_funnel
    fields = [
        :count_domains,
        *SnapshotService::INVITATION,
        *SnapshotService::INVITATION_FUNNEL
    ]

    history(fields)
  end

  def overview
    query = Snapshot
    query = query.where('date >= ?', params[:date]) if params[:date].present?
    query = query.where('date < ?', params[:date_end]) if params[:date_end].present?

    @snapshots = query.all
  end

  private

  def history(fields)
    @totals = snapshot.fields(fields)
    @today = snapshot.fields(fields, true)
    @one_day_ago, @two_days_ago = comparison(1.day, fields)
    @one_week_ago, @two_weeks_ago = comparison(1.week, fields)
    @one_month_ago, @two_months_ago = comparison(1.month, fields)
  end

  def snapshot
    @snapshot ||= SnapshotService.new
  end

  def query_fields(fields)
    fields.map do |field|
      in_funnel = SnapshotService::INVITATION_FUNNEL.include?(field)
      (in_funnel ? "MAX(#{field})" : "SUM(daily_#{field})") + "as #{field}"
    end
  end

  def comparison(interval, fields)
    select_fields = query_fields(fields)

    end_date = Date.today - interval
    start_date = end_date - interval

    values = Snapshot.where('date >= ?', end_date).select(select_fields).all[0]
    base = Snapshot.where('date >= ?', start_date).where('date < ?', end_date).select(select_fields).all[0]

    [values, base]
  end
end
