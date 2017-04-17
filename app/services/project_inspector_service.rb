class ProjectInspectorService < ApplicationService
  # @param project [Project]
  def initialize(project)
    @project = project
  end

  def sync
    raise "Project ##{@project.id} - #{@project.title} does not have a homepage to sync" unless @project.homepage.present?

    params = {connection_timeout: 5, read_timeout: 3, retries: 0, download_images: false}
    page = MetaInspector.new(@project.homepage, params) rescue nil

    if page && page.response.status == 200
      @project.title = page.title if page.title
      @project.description = page.best_description if page.best_description
      @project.thumbnail = page.images.best if page.images.best
      @project.save
    end
  end

  def self.sync_projects(projects)
    result = []

    Project.transaction do
      projects.map do |project|
        begin
          result << ProjectInspectorService.new(project).sync
        rescue
          nil
        end
      end
    end

    result
  end
end
