class Project < ApplicationRecord
  # Relationships
  belongs_to :user

  # Scopes
  scope :ordered, -> { order(position: :asc) }
  scope :visible, -> { where(hide: [false, nil]) }
  scope :invisible, -> { where(hide: true) }

  # Urls
  url :homepage
  website_url :homepage, :thumbnail
  website_url :homepage, :icon
  website_url 'https://github.com', :repository

  def display_title
    return title if title.present?
    return UrlHelper.extract homepage if homepage.present?
    return repository if repository.present?
    'My Project'
  end

  def link
    homepage.present? ? homepage : repository_url
  end
end
