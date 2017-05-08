class User < ApplicationRecord
  # Concerns
  include SocialNetworks

  # Relationships
  has_many :projects
  has_many :invitations, foreign_key: 'inviter_id'
  belongs_to :plan, optional: true

  # Authentication
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:github]

  # Location & Time
  belongs_to :country, optional: true
  belongs_to :city, optional: true
  delegate :timezone, to: :city

  acts_as_geolocated lat: 'latitude', lng: 'longitude'

  # Urls
  url :website
  url :company_website

  # Methods
  def display_name
    name.present? ? name : username
  end

  def first_name
    display_name.split(' ')[0]
  end

  def domain_allowed?
    admin.present? || plan&.domain
  end

  def url
    return UrlHelper.url(domain) if domain && domain_allowed?
    Rails.application.routes.url_helpers.profile_url(host: ENV['APP_DOMAIN'], username: username)
  end

  def completeness_level
    User::CompletenessService.level(completeness)
  end
end
