require 'rails_helper'

RSpec.describe User do
  # Concerns
  it_behaves_like 'social_networks'

  # Foreign Keys
  it { should have_many(:projects) }

  # Methods
  describe '#display_name' do
    let(:user) { User.new(name: 'John Doe', username: 'johndoe') }

    it 'returns name if present' do
      expect(user.display_name).to eq('John Doe')
    end

    it 'returns username without name' do
      user.name = nil
      expect(user.display_name).to eq('johndoe')
    end
  end

  describe '#first_name' do
    it 'gets first of multiple words' do
      expect(User.new(name: 'John Doe').first_name).to eq('John')
    end

    it 'gets name with single word' do
      expect(User.new(username: 'johndoe').first_name).to eq('johndoe')
    end
  end
end
