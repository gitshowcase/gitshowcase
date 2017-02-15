require 'rails_helper'

RSpec.describe Project do
  # Concerns
  it_behaves_like 'github_project'
  it_behaves_like 'website_project'

  # Foreign Keys
  it { should belong_to(:user) }

  describe '#sync' do
    let(:project) { Project.new }

    it 'calls sync methods and saves' do
      expect(project).to receive(:sync_repository)
      expect(project).to receive(:sync_homepage)
      expect(project).to receive(:save!)

      project.sync
    end
  end

  describe '#display_title' do
    let(:project) { Project.new }

    it 'returns title' do
      project.title = 'title'
      expect(project.display_title).to eq('title')
    end

    it 'returns homepage' do
      project.homepage = 'homepage'
      expect(project.display_title).to eq('homepage')
    end

    it 'returns repository' do
      project.repository = 'repository'
      expect(project.display_title).to eq('repository')
    end

    it 'returns default string' do
      expect(project.display_title).to eq('My Project')
    end
  end

  describe '#link' do
    let(:project) { Project.new }

    it 'returns homepage' do
      project.homepage = 'home'
      expect(project.link).to eq('home')
    end

    it 'returns repository' do
      project.repository = 'repo'
      expect(project.link).to eq('https://github.com/repo')
    end
  end
end
