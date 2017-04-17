class SyncProjectRepositoryJob < ApplicationJob
  queue_as :default

  # @param project [Project]
  def perform(project)
    GithubProjectService.new(project).sync
  end
end
