class DomainService < ApplicationService
  def initialize(domain)
    @domain = UrlHelper.extract(domain)

    raise 'Domain management is not enabled' unless self.class.enabled?
    raise 'Invalid domain' unless valid?
  end

  def available(user_id)
    User.where(domain: @domain).where.not(id: user_id).empty?
  end

  def add
    begin
      self.class.client_domain.create(self.class.heroku_app, hostname: @domain)
      self.class.client_domain.create(self.class.heroku_app, hostname: "www.#{@domain}")
    rescue
      raise "Failed to add domain #{@domain}"
    end
  end

  def remove
    begin
      self.class.client_domain.delete(self.class.heroku_app, @domain)
      self.class.client_domain.delete(self.class.heroku_app, "www.#{@domain}")
    rescue
      raise "Failed to delete domain #{@domain}"
    end
  end

  protected

  # @param val [String]
  def valid?
    raise 'Undefined APP_DOMAIN variable' unless ENV['APP_DOMAIN'].present?
    !(@domain.include?(ENV['APP_DOMAIN']))
  end

  def self.enabled?
    heroku_key.present? && heroku_app.present?
  end

  def self.heroku_key
    ENV['HEROKU_KEY']
  end

  def self.heroku_app
    ENV['HEROKU_APP']
  end

  def self.client
    @client ||= PlatformAPI.connect heroku_key
  end

  def self.client_domain
    @client_domain ||= client.domain
  end
end
