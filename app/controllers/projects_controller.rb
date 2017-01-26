class ProjectsController < DashboardController
  before_action :set_project, only: [:show, :edit, :update, :show, :hide, :sync, :destroy]

  # GET /projects
  # GET /projects.json
  def index
    @projects = current_user.projects.ordered
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
    @project.user_id = current_user.id

    if @project.sync
      redirect_to edit_project_url(@project), notice: 'Project was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    if @project.update(project_params)
      redirect_to projects_url, notice: 'Project was successfully updated.'
    else
      render :edit
    end
  end

  # GET /projects/1/show
  def show
    @project.update(hide: false)
  end

  # GET /projects/1/hide
  def hide
    @project.update(hide: true)
  end

  # GET /projects/1/sync
  def sync
    if @project.sync
      redirect_to edit_project_url(@project), notice: 'Project was was successfully synced.'
    else
      render :index
    end
  end

  # POST /projects/order
  def order
    order = params[:order]

    projects = {}
    order.each_with_index do |project_id, position|
      projects[project_id] = {position: position}
    end

    current_user.projects.update(projects.keys, projects.values)
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    redirect_to projects_url, notice: 'Project was successfully destroyed.'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = current_user.projects.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def project_params
    params.require(:project).permit(:title, :homepage, :repository, :description, :thumbnail, :language, :hide)
  end
end
