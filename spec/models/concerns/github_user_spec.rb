RSpec.shared_examples 'github_user' do
  describe '.github_auth' do
    let :user do
      user = described_class.new
    end

    let :auth_data do
      double(
          info: double(
              email: 'email'
          ),
          uid: 'uid',
          credentials: double(
              token: 'token'
          )
      )
    end

    it 'sets data and syncs' do
      expect(described_class).to receive(:new).and_return(user)
      expect(user).to receive(:sync_profile)

      described_class.github_auth auth_data

      expect(user.email).to eq('email')
      expect(user.password).not_to be_empty
      expect(user.github_uid).to eq('uid')
      expect(user.github_token).to eq('token')
      expect(user.role).not_to be_empty
    end
  end

  describe '.sync_profiles' do
    let(:users) { [double.as_null_object, double.as_null_object] }

    it 'calls #sync_profile for each user' do
      expect(users[0]).to receive(:sync_profile).once.with('fields')
      expect(users[1]).to receive(:sync_profile).once.with('fields')
      described_class.sync_profiles('fields', users)
    end
  end

  describe '#company_website=' do
    let(:user) { described_class.new }

    it 'guesses website' do
      user.company_website = '@test'
      expect(user.company_website).to eq('https://github.com/test')
    end

    it 'sets raw website' do
      user.company_website = 'http://test.com'
      expect(user.company_website).to eq('http://test.com')
    end
  end

  describe '#username=' do
    let(:user) { described_class.new }

    it('downcases') do
      user.username = 'Username'
      expect(user.username).to eq('username')
    end
  end

  describe '#sync_profile' do
    let(:user) { FactoryGirl.build(:user) }

    let(:github_client_empty) { instance_double(Octokit::Client, user: github_client_user_empty) }
    let :github_client_user_empty do
      double(
          login: 'johndoe',
          avatar_url: nil,
          name: nil,
          blog: nil,
          location: nil,
          email: nil,
          bio: nil,
          company: nil,
          hireable: nil
      )
    end

    let(:github_client) { instance_double(Octokit::Client, user: github_client_user) }
    let :github_client_user do
      double(
          name: 'John Doe',
          login: 'johndoe',
          avatar_url: 'https://avatars.githubusercontent.com/u/0',
          blog: 'johndoe.com',
          location: 'Brazil',
          email: 'contact@johndoe.com',
          bio: 'Lorem ipsum',
          company: '@company',
          hireable: true
      )
    end

    it 'updates all fields' do
      expect(user).to receive(:github_client).and_return(github_client)
      user.sync_profile

      expect(user.name).to eq('John Doe')
      expect(user.username).to eq('johndoe')
      expect(user.avatar).to eq('https://avatars.githubusercontent.com/u/0?s=400')
      expect(user.website).to eq('johndoe.com')
      expect(user.location).to eq('Brazil')
      expect(user.email).not_to eq('contact@johndoe.com')
      expect(user.display_email).to eq('contact@johndoe.com')
      expect(user.bio).to eq('Lorem ipsum')
      expect(user.company).to eq('@company')
      expect(user.company_website).to eq('https://github.com/company')
      expect(user.hireable).to eq(true)
    end

    it 'updates one field' do
      expect(user).to receive(:github_client).and_return(github_client)
      user.sync_profile 'display_email'

      expect(user.name).to be_nil
      expect(user.display_email).to eq('contact@johndoe.com')
    end

    it 'updates selected fields' do
      expect(user).to receive(:github_client).and_return(github_client)
      user.sync_profile ['display_email', :bio]

      expect(user.name).to be_nil
      expect(user.display_email).to eq('contact@johndoe.com')
      expect(user.bio).to eq('Lorem ipsum')
    end

    it 'does not sync invalid fields' do
      expect(user).not_to receive(:github_client)
      user.sync_profile 'id'
    end

    it 'does not update company_website without @company' do
      expect(github_client_user).to receive(:company).and_return('company')
      expect(user).to receive(:github_client).once.and_return(github_client)
      user.sync_profile

      expect(user.company_website).to be_nil
    end

    it 'syncs with nil fields' do
      expect(user).to receive(:github_client).once.and_return(github_client_empty)
      user.sync_profile
    end
  end

  describe '#sync_projects' do
    let(:user) { described_class.new }

    it 'returns github and website projects' do
      expect(Project).to receive(:sync_by_user).with(user).and_return(['repo_project'])
      expect(user).to receive(:sync_website_project).and_return('website_project')
      expect(user.sync_projects).to eq(['repo_project', 'website_project'])
    end
  end

  describe '#sync_website_project' do
    let(:user) { FactoryGirl.create(described_class.to_s.downcase, website: 'website') }

    it 'returns nil without website' do
      user = described_class.new
      expect(user.sync_website_project).to be_nil
    end

    it 'returns nil with existing website' do
      user.projects.new(homepage: 'website').save
      expect(user.sync_website_project).to be_nil
    end

    it 'syncs' do
      project = double

      expect(user.projects).to receive(:new).with(homepage: 'website', position: 0).and_return(project)
      expect(project).to receive(:sync_homepage)
      expect(user.sync_website_project).to be(project)
    end
  end
end