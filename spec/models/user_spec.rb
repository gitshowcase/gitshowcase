require "rails_helper"

RSpec.describe User do
  it { should have_many(:projects) }

  describe '#sync' do
    let(:user) { User.new }

    it 'syncs the profile' do
      allow(user).to receive(:sync_skills_projects)
      expect(user).to receive(:sync_profile)

      user.sync
    end

    it 'syncs the skills' do
      allow(user).to receive(:sync_profile)
      expect(user).to receive(:sync_skills_projects)

      user.sync
    end
  end

  describe '#sync_profile' do
    let(:user) { FactoryGirl.build(:user) }

    let(:github_client) do
      instance_double(Octokit::Client, user: github_user)
    end

    let(:github_user) do
      double(
        avatar_url: avatar_url,
        login: 'johndoe',
        name: 'John Doe',
        blog: 'https://medium.com/@johndoe',
        location: 'Brazil',
        email: 'johndoe@example.com',
        hireable: 'true',
        bio: 'Lorem ipsum dolor sit amet consectetur.',
        company: company
      )
    end

    let(:company) { '@example' }

    let(:avatar_url) { 'https://avatars.githubusercontent.com/u/2944985?v=3&s=200' }

    before do
      allow(user).to receive(:client).and_return(github_client)
    end

    it 'updates the username' do
      user.sync_profile

      expect(user.username).to eq(github_user.login)
    end

    it 'updates the avatar' do
      user.sync_profile

      expect(user.avatar).to eq(avatar_url)
    end

    it 'updates the name' do
      user.sync_profile

      expect(user.name).to eq(github_user.name)
    end

    it 'updates the website' do
      user.sync_profile

      expect(user.website).to eq(github_user.blog)
    end

    it 'updates the location' do
      user.sync_profile

      expect(user.location).to eq(github_user.location)
    end

    it 'updates the email' do
      user.sync_profile

      expect(user.email).to eq(github_user.email)
    end

    it 'updates the hireable info' do
      user.sync_profile

      expect(user.hireable).to be_truthy
    end

    it 'updates the bio' do
      user.sync_profile

      expect(user.bio).to eq(github_user.bio)
    end

    it 'updates the company' do
      user.sync_profile

      expect(user.company).to eq(github_user.company)
    end

    describe 'company website' do
      context 'when company name starts with a @ sign' do
        it 'sets the company website' do
          user.sync_profile

          expected = "https://github.com/example"

          expect(user.company_website).to eq(expected)
        end
      end

      context 'when company name does not start with a @ sign' do
        let(:company) { 'Foo Bar' }

        it 'does not set the company website' do
          user.sync_profile

          expect(user.company_website).to be_nil
        end
      end
    end

    context 'when no size is set on avatar' do
      let(:avatar_url) { 'https://avatars.githubusercontent.com/u/2944985?v=3' }

      it 'adds an optimized size to avatar url' do
        user.sync_profile

        expected = avatar_url + '&s=400'

        expect(user.avatar).to eq(expected)
      end
    end
  end

  describe '#sync_skills_projects' do
    let(:user) { FactoryGirl.build(:user) }

    let(:github_client) do
      instance_double(Octokit::Client, repositories: repositories)
    end

    let(:repositories) do
      [
        double(name: 'foo', homepage: nil, language: 'ruby',
               full_name: 'johndoe/foo', description: 'lorem'),
        double(name: 'bar', homepage: nil, language: 'javascript',
               full_name: 'johndoe/bar', description: 'lorem')
      ]
    end

    before do
      allow(user).to receive(:client).and_return(github_client)
    end

    it 'sets the skills with default values' do
      user.sync_skills_projects

      expect(user.skills['ruby']).to eq(User::DEFAULT_SKILL_VALUE)
      expect(user.skills['javascript']).to eq(User::DEFAULT_SKILL_VALUE)
    end
  end
end
