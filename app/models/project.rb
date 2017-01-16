class Project < ApplicationRecord
  belongs_to :user

  def sync(data)
    sync_repository(data)
    sync_homepage

    self.save
  end

  def sync_repository(data)
    self.title = data.name.titleize
    self.url = data.html_url
    self.homepage = data.homepage
    self.repository = data.full_name
    self.description = data.description
    self.language = data.language
  end

  def sync_homepage()
    return false unless self.homepage

    begin
      page = MetaInspector.new(self.homepage)
      return false unless page.response.status == 200

      self.title = page.title if page.title
      self.description = page.best_description if page.best_description
      self.icon = page.images.favicon if page.images.favicon
      self.cover = page.images.best if page.images.best

      manifest = page.head_links.select {|link| link[:rel] == 'manifest'}.first[:href]
      self.manifest = manifest if manifest
    rescue
      return false
    end

    false
  end
end
