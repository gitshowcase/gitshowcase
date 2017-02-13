require 'rails_helper'

RSpec.describe User do
  # Concerns
  it_behaves_like 'social_networks'
  it_behaves_like 'github_user', User

  # Foreign Keys
  it { should have_many(:projects) }

  # Methods
  describe '#display_name' do
    it 'when name' do
      expect(User.new(name: 'John Doe').display_name).to eq('John Doe')
    end

    it 'when username' do
      expect(User.new(username: 'johndoe').display_name).to eq('johndoe')
    end
  end

  describe '#first_name' do
    it 'when display name has spaces' do
      expect(User.new(name: 'John Doe').first_name).to eq('John')
    end

    it 'when display_name is a word' do
      expect(User.new(username: 'johndoe').first_name).to eq('johndoe')
    end
  end

  describe '#sync_projects_skills' do
    let(:user) { described_class.new }

    it 'calls methods' do
      expect(user).to receive(:sync_projects).and_return('projects')
      expect(user).to receive(:add_skills_by_projects).with('projects')
      user.sync_projects_skills
    end
  end

  describe '#add_skills_by_projects' do
    let(:user) { FactoryGirl.create(described_class.to_s.downcase, skills: {'ruby': 5}) }
    let :projects do
      [
          double(language: 'ruby'),
          double(language: 'php'),
          double(language: 'javascript')
      ]
    end

    it 'adds skills by project languages' do
      user.add_skills_by_projects(projects)
      expect(user.skills).to eq({'ruby' => 5, 'php' => 3, 'javascript' => 3})
    end
  end

  describe '#update_skills' do
    let(:user) {
      user = FactoryGirl.create(:user)
      user.update_skills({'javascript': 3, 'ruby': 6, 'backpacking': -1})

      user
    }

    it 'has the exact amount of skills' do
      expect(user.skills.length).to eq(3)
    end

    it 'updates mastery' do
      expect(user.skills['javascript']).to eq(3)
    end

    it 'fixes masteries out of range' do
      expect(user.skills['ruby']).to eq(5)
      expect(user.skills['backpacking']).to eq(0)
    end
  end
end
