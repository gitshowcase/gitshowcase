require 'rails_helper'

RSpec.describe UrlHelper, type: :helper do
  describe '.is_url' do
    it 'is true for http' do
      expect(UrlHelper.is_url('http://www.url.com')).to be(true)
    end

    it 'is true for https' do
      expect(UrlHelper.is_url('https://www.not-a-url.com')).to be(true)
    end

    it 'is not true without protocl' do
      expect(UrlHelper.is_url('www.not-a-url.com')).to be(false)
    end
  end

  describe '.url' do
    it 'is nil without path' do
      expect(UrlHelper.url('')).to be_nil
    end

    context 'path is an url' do
      it 'returns path' do
        expect(UrlHelper.url('http://url.com')).to eq('http://url.com')
      end
    end

    context 'path is not an url' do
      it 'returns path with protocol' do
        expect(UrlHelper.url('not-a-url.com', 'https')).to eq('https://not-a-url.com')
      end
    end
  end

  describe '.extract' do
    it 'removes protocol' do
      expect(UrlHelper.extract('http://example.com')).to eq('example.com')
    end

    it 'removes www.' do
      expect(UrlHelper.extract('www.example.com')).to eq('example.com')
    end

    it 'removes domain' do
      expect(UrlHelper.extract('example.com/test', 'example.com')).to eq('/test')
    end
  end

  describe '.protocol' do
    it 'returns https' do
      expect(UrlHelper.protocol('https://example.com')).to eq('https')
    end

    it 'returns http' do
      expect(UrlHelper.protocol('http://example.com')).to eq('http')
    end
  end

  describe '.website_url' do
    context 'without path' do
      it 'returns nil' do
        expect(UrlHelper.website_url(nil, '')).to be_nil
      end
    end

    context 'with url path' do
      it 'returns path' do
        expect(UrlHelper.website_url(nil, 'http://example.com/after')).to eq('http://example.com/after')
      end
    end

    context 'without website' do
      it 'returns url' do
        expect(UrlHelper.website_url('', 'example.com/after', 'https')).to eq('https://example.com/after')
      end
    end

    context 'path with website' do
      it 'returns url' do
        expect(UrlHelper.website_url('example.com', 'example.com/after')).to eq('http://example.com/after')
      end
    end

    it 'returns full url' do
      expect(UrlHelper.website_url('example.com', 'after', 'https')).to eq('https://example.com/after')
    end
  end
end
