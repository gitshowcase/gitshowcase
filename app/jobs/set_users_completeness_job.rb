class SetUsersCompletenessJob < ApplicationJob
  queue_as :default

  def perform
    User.transaction do
      User.where('completeness is null').each do |user|
        User::CompletenessService.new(user).reset
      end
    end
  end
end
