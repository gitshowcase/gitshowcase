module WebsiteProject
  extend ActiveSupport::Concern

  def sync_homepage
    return false unless homepage.present?

    begin
      page = MetaInspector.new(homepage)
      return false unless page.response.status == 200

      self.title = page.title if page.title
      self.description = page.best_description if page.best_description
      self.thumbnail = page.images.best if page.images.best
    rescue
      return false
    end

    true
  end
end
