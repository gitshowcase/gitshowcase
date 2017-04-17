class RemoveDomainJob < ApplicationJob
  queue_as :default

  # @param domain [String]
  def perform(domain)
    DomainService.new(domain).remove
  end
end
