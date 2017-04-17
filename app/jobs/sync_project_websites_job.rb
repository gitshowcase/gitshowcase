class SyncProjectWebsitesJob < ApplicationJob
  queue_as :default

  # @param projects [Project[]]
  def perform(projects)
    ProjectInspectorService.sync_projects(projects)
  end
end
