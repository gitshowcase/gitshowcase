class CreateSnapshotJob < ApplicationJob
  queue_as :default

  # @param date [Date]
  def perform(date = nil)
    date ||= Date.today - 1.day
    SnapshotService.new(date).create
  end
end
