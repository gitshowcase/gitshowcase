class SyncUserProjectWebsitesJob < ApplicationJob
  queue_as :default

  # @param user [User]
  def perform(user)
    ProjectInspectorService.sync_projects(user.projects)
  end
end
