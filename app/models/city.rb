class City < ApplicationRecord
  include PgSearch

  # Relationships
  belongs_to :state, optional: true
  belongs_to :country
  belongs_to :timezone
  has_many :users

  # Geo search
  acts_as_geolocated

  # Name search
  pg_search_scope :search,
                  against: :full_name,
                  order_within_rank: 'capital DESC',
                  ignoring: :accents,
                  using: {trigram: {threshold: 0.3}}

  pg_search_scope :loose_search,
                  against: :full_name,
                  order_within_rank: 'capital DESC',
                  ignoring: :accents,
                  using: {trigram: {threshold: 0.15}}
end
