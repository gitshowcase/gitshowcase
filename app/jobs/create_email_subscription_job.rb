class CreateEmailSubscriptionJob < ApplicationJob
  queue_as :default

  # @param user [User]
  def perform(user)
    EmailSubscriptionService.new(user).create
  end
end
