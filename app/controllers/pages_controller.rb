class PagesController < ApplicationController
  def not_found
    @title = 'Not Found'
    @background = 'backgrounds/cat-lightsaber.gif'
    render status: 404
  end

  def internal_server_error
    @title = 'Something Went Wrong'
    @background = 'backgrounds/cat-lightsaber.gif'
    render status: 500
  end

  def license
    @title = 'License'
  end

  def privacy_policy
    @title = 'Privacy Policy'
  end

  def sitemap_users
    service = SitemapService.new('sitemap-users.cache.xml')
    service.create unless service.valid?

    render layout: nil, file: service.path, content_type: 'application/xml'
  end

  def letsencrypt
    render text: ENV['SSL_ACME_TEXT']
  end
end
