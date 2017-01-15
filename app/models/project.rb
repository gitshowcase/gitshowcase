class Project < ApplicationRecord
  belongs_to :user

  def sync(data)
    sync_repository(data)
    sync_homepage

    self.save
  end

  private

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

      self.title = page.title
      self.description = page.best_description
      self.icon = page.images.favicon
      self.cover = page.images.best
    rescue
      return false
    end

    false
  end
end
