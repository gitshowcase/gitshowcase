class Admin::UsersController < AdminController
  before_action :set_user, only: [:show]

  SEARCH_FIELDS = %w[name username email location role domain]

  # GET /admin/users
  def index
    @levels = levels = User::CompletenessService::LEVELS.keys
    @search_fields = SEARCH_FIELDS

    query = User.order('id DESC')

    @filters = {
        search: params[:search],
        field: params[:field] || Hash[SEARCH_FIELDS.map { |field| [field, true] }],
        completeness: params[:completeness] || Hash[@levels.map { |key| [key.to_s, true] }],
        funnel: params[:funnel] || Hash[%w[no_domain 0 1 2 3 4 5 6+].map { |key| [key, true] }]
    }

    if @filters[:search].present?
      fields = SEARCH_FIELDS.map { |field| "#{field} ILIKE ?" if @filters[:field].key? field }.compact
      query = query.where("(#{fields.join(' OR ')})", *(["%#{@filters[:search]}%"] * fields.count))
    end

    if levels != @filters[:completeness].keys.map { |key| key.to_sym }
      where = []
      values = []

      @levels.each do |level|
        if @filters[:completeness].key? level
          completeness_query = SnapshotService.completeness_query(level)
          where << completeness_query[:where]
          values = [*values, *completeness_query[:values]]
        end
      end

      if where.count > 0
        query = query.where("(#{where.join(' OR ')})", *values)
      end
    end

    @users = query.paginate(page: params[:page], per_page: 15)
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
