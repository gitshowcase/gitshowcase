class DeleteEmailSubscriptionJob < ApplicationJob
  queue_as :default

  # @param email [String]
  def perform(email)
    EmailSubscriptionService.new(User.new(email: email)).delete
  end
end
