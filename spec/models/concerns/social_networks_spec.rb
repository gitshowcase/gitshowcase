RSpec.shared_examples 'social_networks' do
  describe '#included' do
    let (:user) { described_class.new(linkedin: 'http://linkedin.com/in/john_in') }

    it 'creates getter' do
      expect(user.linkedin).to eq('https://linkedin.com/in/john_in')
    end

    it 'creates setter' do
      expect(user[:linkedin]).to eq('john_in')
    end
  end

  describe '#github' do
    let (:user) { described_class.new(username: 'johndoe') }

    it 'returns github profile' do
      expect(user.github).to eq('https://github.com/johndoe')
    end
  end

  describe 'socials' do
    let (:user) { described_class.new(username: 'johndoe', linkedin: 'john_in', blog: 'my_blog') }
    let (:socials) do
      {
          github: 'https://github.com/johndoe',
          linkedin: 'https://linkedin.com/in/john_in',
          blog: 'http://my_blog'
      }
    end

    it 'get existing socials' do
      expect(user.socials).to eq(socials)
    end
  end
end
