class SitemapService < ApplicationService
  def initialize(filename = 'sitemap-users.cache.xml', users = nil)
    @filename = filename
    @users = users
  end

  def path
    Rails.root.join('public', @filename)
  end

  def valid?
    exists? && !old?
  end

  def users
    @users || User.select(:username)
  end

  def create
    map = XmlSitemap::Map.new('www.gitshowcase.com', home: false, secure: true) do |m|
      users.each do |user|
        m.add user.username if user.username.present? && user.username != 'showcasecat'
      end
    end

    map.render_to path
  end

  private

  def exists?
    File.exist?(path)
  end

  def old?
    File.mtime(path) < 1.second.ago
  end
end
