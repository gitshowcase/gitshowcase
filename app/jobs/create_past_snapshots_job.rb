class CreatePastSnapshotsJob < ApplicationJob
  queue_as :default

  def perform
    initial_date = User.order('created_at asc').first.created_at.to_date
    (initial_date..(Date.today - 1.day)).each do |date|
      SnapshotService.new(date).create
    end
  end
end
