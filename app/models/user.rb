class User < ApplicationRecord
  # Concerns
  include SocialNetworks

  # Relationships
  has_many :projects

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
    admin.present?
  end
end
