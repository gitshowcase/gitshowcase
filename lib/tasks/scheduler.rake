desc 'This task is called by the Heroku scheduler add-on'

task :create_snapshot => :environment do
  CreateSnapshotJob.perform_later
end
