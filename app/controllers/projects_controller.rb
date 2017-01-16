class ProjectsController < DashboardController
  before_action :set_project, only: [:show, :edit, :update, :sync, :destroy]

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.all
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

    respond_to do |format|
      if @project.save
        format.html { redirect_to edit_project_url(@project), notice: 'Project was successfully created.' }
        format.json { render :edit, status: :created, location: edit_project_url(@project) }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to projects_url, notice: 'Project was successfully updated.' }
        format.json { render :index, status: :ok }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def sync
    respond_to do |format|
      if @project.sync
        format.html { redirect_to edit_project_url(@project), notice: 'Project was was successfully synced.' }
        format.json { render :index, status: :ok }
      else
        format.html { render :index }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = current_user.projects.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:title, :homepage, :repository, :url, :description, :icon, :cover, :language, :manifest, :hide)
    end
end
