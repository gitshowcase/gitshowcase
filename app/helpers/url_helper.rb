module UrlHelper
  # @param path [String]
  def self.is_url(path)
    path.include?('http://') or path.include?('https://')
  end

  # @param path [String]
  # @param protocol [String]
  def self.url(path, protocol = 'http')
    return nil unless path.present?
    is_url(path) ? path : "#{protocol}://#{path}"
  end

  # @param path [String]
  # @param domain [String]
  def self.extract(path, domain = '')
    result = path.sub(/^https?\:\/\//, '').sub(/^www./, '')
    domain ? result.sub(domain, '') : result
  end

  # @param path [String]
  def self.protocol(path)
    path.include?('https://') ? 'https' : 'http'
  end

  # @param website [String]
  # @param path [String]
  # @param protocol [String]
  def self.website_url(website, path, protocol = 'http')
    return nil unless path.present?
    return path if is_url(path)
    return url(path, protocol) if !website.present? || path.include?(extract(website))

    pre = website.present? ? "#{website}/" : ''
    url("#{pre}#{path}", protocol)
  end
end
