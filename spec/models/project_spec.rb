require "rails_helper"

RSpec.describe Project do
  it { should belong_to(:user) }
end
