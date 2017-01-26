class PagesController < ApplicationController
  def letsencrypt
    render text: ENV['SSL_ACME_TEXT']
  end
end
