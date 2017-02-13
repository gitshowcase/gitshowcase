class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.url(url)
    define_method("#{url}_url") { UrlHelper.url self[url] }
  end

  def self.website_url(website, path)
    define_method("#{path}_url") do
      website = website.is_a?(String) ? website : self[website]
      UrlHelper.website_url website, self[path]
    end
  end
end
