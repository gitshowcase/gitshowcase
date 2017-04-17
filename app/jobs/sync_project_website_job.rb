class SyncProjectWebsiteJob < ApplicationJob
  queue_as :default

  # @param project [Project]
  def perform(project)
    ProjectInspectorService.new(project).sync
  end
end
