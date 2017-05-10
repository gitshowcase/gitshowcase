class Snapshot < ApplicationRecord
  validate :date_must_be_in_the_past

  def date_must_be_in_the_past
    errors.add(:date, 'must be in the past') unless date < Date.today
  end
end
