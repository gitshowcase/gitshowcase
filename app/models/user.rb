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
    domain if domain && domain_allowed?
    Rails.application.routes.url_helpers.profile_path(username: username)
  end
end
