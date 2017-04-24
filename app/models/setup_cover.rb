class SetupCover < ApplicationRecord
  def profile
    "#{url}?w=1024&h=768"
  end

  def small
    "#{url}?w=256&h=170"
  end
end
