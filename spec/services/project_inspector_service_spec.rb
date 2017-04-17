require 'rails_helper'

RSpec.describe ProjectInspectorService, type: :service do
  describe '#sync' do
    subject(:service) { ProjectInspectorService.new(project) }

    context 'without homepage' do
      let(:project) { FactoryGirl.build(:project, id: 0, title: 'title') }

      it 'raises exception' do
        expect { service.sync }.to raise_exception 'Project #0 - title does not have a homepage to sync'
      end
    end

    context 'with existing homepage' do
      let(:project) { FactoryGirl.build(:project, homepage: 'gitshowcase.com') }

      it 'syncs attributes' do
        VCR.use_cassette 'websites/gitshowcase' do
          expect { service.sync }.to change(project, :title).to('GitShowcase').and \
          change(project, :description).to('Developer, feature your best projects in a plug and play portfolio. The best part, for free.').and \
          change(project, :thumbnail).to('https://www.gitshowcase.com/preview.png')

          expect(project.persisted?).to be_truthy
        end
      end
    end

    context 'with invalid homepage' do
      let(:project) { FactoryGirl.build(:project, homepage: '404.not.found.gitshowcase.com') }

      it 'does not update attributes' do
        VCR.use_cassette 'websites/404' do
          expect { service.sync }.not_to change(project, :title)
          expect(project.description).to be_nil
          expect(project.thumbnail).to be_nil
          expect(project.persisted?).to be_falsey
        end
      end
    end
  end

  describe '.sync_projects' do
    subject :call_sync do
      VCR.use_cassette 'websites/gitshowcase' do
        ProjectInspectorService.sync_projects([project, homeless_project])
      end
    end

    let(:project) { FactoryGirl.build(:project, homepage: 'gitshowcase.com') }
    let(:homeless_project) { FactoryGirl.build(:project) }

    it 'syncs projects' do
      expect { call_sync }.to change(project, :title).to('GitShowcase')
      expect(homeless_project.id).to be_falsey
    end

    it 'does not raise with homeless project' do
      expect { call_sync }.not_to raise_exception
    end

    it 'returns synced projects' do
      expect { call_sync }.not_to raise_exception
    end
  end
end
