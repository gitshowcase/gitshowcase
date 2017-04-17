require 'rails_helper'

RSpec.describe GithubProjectService, type: :service do
  describe '#sync' do
    context 'without repository' do
      subject(:service) { GithubProjectService.new(project) }
      let(:project) { FactoryGirl.build(:project, repository: '', title: 'title', id: 0) }

      it 'raises message' do
        expect { service.sync }.to raise_exception 'Project #0 - title does not have a repository to sync'
      end
    end

    context 'with repository' do
      subject(:service) { GithubProjectService.new(project) }
      let(:project) { FactoryGirl.build(:project, repository: 'gitshowcase/gitshowcase') }

      it 'fetches repository data' do
        client = double
        allow(service).to receive(:client).and_return (client)
        expect(client).to receive(:repository).with('gitshowcase/gitshowcase').and_return(spy)
        expect_any_instance_of(Project).to receive(:save)

        service.sync
      end

      it 'uses given data' do
        client = double
        allow(service).to receive(:client).and_return (client)
        expect(client).to_not receive(:repository)
        expect_any_instance_of(Project).to receive(:save)

        service.sync(spy)
      end

      it 'changes attributes' do
        VCR.use_cassette 'projects/gitshowcase' do
          expect { service.sync }.to change(project, :title).to('Gitshowcase').and \
              change(project, :homepage).to('https://www.gitshowcase.com').and \
              change(project, :description).to('Awesome Portfolio from your GitHub').and \
              change(project, :language).to('Ruby').and \
              change(project, :fork).to(false).and \
              change(project, :stars).to(98).and \
              change(project, :forks).to(14)

          expect(project.repository).to eq('gitshowcase/gitshowcase')
          expect(project.persisted?).to be_truthy
        end
      end
    end
  end

  describe '.sync' do
    it 'syncs individually' do
      service_doubles = [spy, spy]
      projects = FactoryGirl.create_list(:project, 2)

      expect(GithubProjectService).to receive(:new).twice.and_return(service_doubles[0], service_doubles[1])
      expect(service_doubles[0]).to receive(:sync)
      expect(service_doubles[1]).to receive(:sync)

      GithubProjectService.sync(projects)
    end
  end

  describe '.sync_by_user' do
    it 'returns projects created' do
      user = FactoryGirl.create(:user)
      repositories = [
          double(full_name: 'author/repo0'),
          double(full_name: 'author/repo1'),
          double(full_name: 'author/repo2')
      ]

      FactoryGirl.create(:project, user_id: user.id, repository: 'author/repo0')
      allow(GithubProjectService).to receive(:client).with(user).and_return(double(repositories: repositories))
      allow_any_instance_of(GithubProjectService).to receive(:sync)

      created = GithubProjectService.sync_by_user(user)
      expect(created.size).to eq(2)

      GithubProjectService.sync_by_user(user)
    end
  end
end
