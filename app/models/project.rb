class Project < ApplicationRecord
  belongs_to :user

  def sync_repository(data)
    self.title = data.name.titleize
    self.url = data.html_url
    self.homepage = data.homepage
    self.repository = data.full_name
    self.description = data.description
    self.language = data.language

    self.save
  end
end
