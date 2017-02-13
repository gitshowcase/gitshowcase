RSpec.shared_examples 'website_project' do
  describe '#sync_homepage' do
    let(:project) { described_class.new(homepage: 'example.com') }

    let :meta_not_found do
      double(
          response: double(
              status: 404
          )
      )
    end

    let :meta_response do
      double(
          response: double(
              status: 200
          ),

          title: 'Foo',
          best_description: 'Bar',
          images: double(
              best: 'image.png'
          )
      )
    end

    let :meta_response_empty do
      double(
          response: double(
              status: 200
          ),

          title: nil,
          best_description: nil,
          images: double(
              best: nil
          )
      )
    end

    it 'returns false without homepage' do
      project.homepage = nil
      expect(project.sync_homepage).to be_falsey
    end

    it 'returns false with bad response' do
      expect(MetaInspector).to receive(:new).and_return(meta_not_found)
      expect(project.sync_homepage).to be_falsey
    end

    it 'sets data' do
      expect(MetaInspector).to receive(:new).and_return(meta_response)

      project.sync_homepage

      expect(project.title).to eq('Foo')
      expect(project.description).to eq('Bar')
      expect(project.thumbnail).to eq('image.png')
    end

    it 'does not set data' do
      expect(MetaInspector).to receive(:new).and_return(meta_response_empty)

      project.title = 'old title'
      project.description = 'old description'
      project.thumbnail = 'old thumbnail'

      project.sync_homepage

      expect(project.title).to eq('old title')
      expect(project.description).to eq('old description')
      expect(project.thumbnail).to eq('old thumbnail')
    end
  end
end
