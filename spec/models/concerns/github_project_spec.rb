RSpec.shared_examples 'github_project' do
  describe '.sync_by_user' do
    let(:existing_repository) { double(full_name: 'username/existing').as_null_object }
    let(:new_repository) { double(full_name: 'username/new').as_null_object }
    let(:website_repository) { double(homepage: 'username/website').as_null_object }
    let(:github_client) { instance_double(Octokit::Client, repositories: [new_repository, existing_repository, website_repository]) }

    let(:user) {
      user = FactoryGirl.create(:user)
      FactoryGirl.create(:project, user: user, repository: 'username/existing')

      user
    }

    it 'syncs projects' do
      expect(user).to receive(:github_client).and_return(github_client)
      synced_projects = Project.sync_by_user(user)

      expect(synced_projects.count).to eq(2)
      expect(synced_projects[0].repository).to eq('username/new')
      expect(synced_projects[1].homepage).to eq('username/website')
      expect(user.projects.count).to eq(3)
    end
  end

  describe '#sync_repository' do
    let (:project) { FactoryGirl.create(described_class.to_s.downcase, repository: 'repo') }

    let :repository_data do
      double(
          name: 'project name',
          homepage: 'example.com',
          full_name: 'user/repo',
          description: 'Repo description',
          language: 'ruby'
      )
    end

    let(:client_data) { double(repository: repository_data) }

    it 'returns false without repository' do
      project.repository = nil
      expect(project.sync_repository).to be_falsey
    end

    it 'uses given data' do
      expect(project).not_to receive(:user)
      project.sync_repository(repository_data)
    end

    it 'sets data' do
      expect(project.user).to receive(:github_client).and_return(client_data)

      project.sync_repository

      expect(project.title).to eq('Project Name')
      expect(project.homepage).to eq('example.com')
      expect(project.repository).to eq('user/repo')
      expect(project.description).to eq('Repo description')
      expect(project.language).to eq('ruby')
    end
  end
end
