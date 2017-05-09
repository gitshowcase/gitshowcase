class SetUsersCompletenessJob < ApplicationJob
  queue_as :default

  def perform
    User.transaction do
      User.each do |user|
        User::CompletenessService.new(user).reset
      end
    end
  end
end
