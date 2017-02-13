class Project < ApplicationRecord
  # Concerns
  include GithubProject
  include WebsiteProject

  # Relationships
  belongs_to :user

  # Scopes
  scope :ordered, -> { order(position: :asc) }

  # Urls
  url :homepage
  website_url :homepage, :thumbnail
  website_url :homepage, :icon
  website_url 'https://github.com', :repository

  # Other Methods
  def sync(data = nil)
    sync_repository(data)
    sync_homepage
    save!
  end

  def display_title
    [title, homepage, repository].each { |val| return val if val.present? }
    'My Project'
  end
end
