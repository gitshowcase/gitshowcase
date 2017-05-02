class Country < ApplicationRecord
  include PgSearch

  # Relationships
  belongs_to :continent
  has_many :states
  has_many :timezones
  has_many :users

  # Name search
  pg_search_scope :search,
                  against: :name,
                  ignoring: :accents,
                  using: {trigram: {threshold: 0.2}}
end
