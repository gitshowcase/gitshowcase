RSpec.shared_examples 'social_networks' do
  describe 'included' do
    subject (:user) { described_class.new(linkedin: 'http://linkedin.com/in/john_in') }

    it 'creates getter' do
      expect(user.linkedin).to eq('https://linkedin.com/in/john_in')
    end

    it 'creates setter' do
      expect(user[:linkedin]).to eq('john_in')
    end

    it 'gets blog with https' do
      user.blog = 'https://john.com'
      expect(user.blog).to eq('https://john.com')
    end

    it 'gets blog without protocol' do
      user.blog = 'john.com'
      expect(user.blog).to eq('http://john.com')
    end
  end

  describe '#github' do
    subject (:user) { described_class.new(username: 'johndoe') }

    it 'returns github profile' do
      expect(user.github).to eq('https://github.com/johndoe')
    end
  end

  describe 'socials' do
    subject (:user) { described_class.new(username: 'johndoe', linkedin: 'john_in', blog: 'my_blog') }

    it 'gets existing socials' do
      socials = {
          github: 'https://github.com/johndoe',
          linkedin: 'https://linkedin.com/in/john_in',
          blog: 'http://my_blog'
      }

      expect(user.socials).to eq(socials)
    end
  end
end
