module HerokuUser
  extend ActiveSupport::Concern

  class_methods do
    def heroku_key
      ENV['HEROKU_KEY']
    end

    def heroku_app
      ENV['HEROKU_APP']
    end

    def heroku_client
      @heroku_client = PlatformAPI.connect heroku_key
    end

    def heroku_enabled?
      return heroku_key.present? && heroku_app.present?
    end
  end

  included do
    after_update :heroku_update_domain
    after_destroy :heroku_delete_domain
  end

  def domain_valid?(val)
    !(val.include?(ENV['APP_DOMAIN']))
  end

  def domain_available?(val)
    user = self.class.find_by_domain(val)
    user.nil? || user.id == id
  end

  # @param val [String]
  def domain=(val)
    if val
      raise "*.#{ENV['APP_DOMAIN']} domains forbidden" unless domain_valid?(val)
      raise "#{ENV['APP_DOMAIN']} already in use" unless domain_available?(val)
    end

    self[:domain] = val
  end

  def heroku_create_domain(hostname = domain)
    return unless hostname.present?

    begin
      self.class.heroku_client.domain.create(self.class.heroku_app, hostname: hostname)
    rescue
      raise "Failed to create domain #{hostname}, it's probably already in use on Heroku"
    end
  end

  def heroku_update_domain
    return unless domain_changed?

    heroku_delete_domain domain_was
    heroku_create_domain
  end

  def heroku_delete_domain(hostname = domain)
    return unless self.class.heroku_enabled? && hostname.present?

    begin
      self.class.heroku_client.domain.delete(self.class.heroku_app, hostname)
    rescue
      logger.warn "Failed to delete domain #{hostname}"
    end
  end
end
