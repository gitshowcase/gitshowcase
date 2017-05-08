require 'rails_helper'

RSpec.describe User::SkillsService, type: :service do
  let(:user) { FactoryGirl.create(:user, skills: {'rails': 5}) }
  let(:service) { User::SkillsService.new(user) }

  describe '#import' do
    context 'without projects' do
      it 'fetches user projects' do
        expect(user).to receive(:projects).and_return([])
        service.import
      end
    end

    context 'with projects' do
      let(:project_with_language) { instance_double(Project, language: 'ruby') }
      let(:project_without_language) { instance_double(Project, language: nil) }
      let(:project_with_existing_language) { instance_double(Project, language: 'rails') }
      let(:projects) { [project_with_language, project_without_language, project_with_existing_language] }

      it 'does not fetch user projects' do
        expect(user).to_not receive(:projects)
        service.import(projects)
      end

      it 'updates projects' do
        service.import(projects)
        expect(user.skills).to eq('ruby' => User::SkillsService::DEFAULT_SKILL_MASTERY, 'rails' => 5)
      end
    end
  end

  describe '#update' do
    let(:skills) { {ruby: -1, rails: 4, javascript: 6} }
    before { service.set(skills) }

    it 'sets minimum mastery' do
      expect(user.skills['ruby']).to eq(0)
    end

    it 'sets maximum mastery' do
      expect(user.skills['javascript']).to eq(5)
    end

    it 'sets in range mastery' do
      expect(user.skills['rails']).to eq(4)
    end
  end
end
