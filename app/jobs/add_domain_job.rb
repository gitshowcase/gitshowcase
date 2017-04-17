class AddDomainJob < ApplicationJob
  queue_as :default

  # @param domain [sSring]
  def perform(domain)
    DomainService.new(domain).add
  end
end
