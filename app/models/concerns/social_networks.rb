module SocialNetworks
  extend ActiveSupport::Concern

  SOCIALS_NETWORKING = {
      linkedin: 'linkedin.com/in',
      angellist: 'angel.co',
      twitter: 'twitter.com',
      facebook: 'facebook.com',
      google_plus: 'plus.google.com'
  }

  SOCIALS_DEVELOPMENT = {
      stack_overflow: 'stackoverflow.com/users',
      codepen: 'codepen.io',
      jsfiddle: 'jsfiddle.net'
  }

  SOCIALS_WRITING = {
      medium: 'medium.com',
      blog: ''
  }

  SOCIALS_DESIGN = {
      behance: 'behance.net',
      dribbble: 'dribbble.com',
      pinterest: 'pinterest.com'
  }

  GROUPED_SOCIALS = [
      [:networking, SOCIALS_NETWORKING],
      [:writing, SOCIALS_WRITING],
      [:development, SOCIALS_DEVELOPMENT],
      [:design, SOCIALS_DESIGN]
  ]

  HASH_SOCIALS = GROUPED_SOCIALS.flat_map { |group| group[1].map { |social| [social[0], social[1]] } }.to_h
  SOCIALS = HASH_SOCIALS.flat_map { |social, _| social }

  included do
    # Create getters and setters
    SOCIALS.each do |social|
      define_method("#{social}") { UrlHelper.website_url(HASH_SOCIALS[social], self[social], social == :blog ? 'http' : 'https') }
      define_method("#{social}=") { |val| self[social] = HASH_SOCIALS[social].present? ? UrlHelper.extract(val, "#{HASH_SOCIALS[social]}/") : val }
    end
  end

  def github
    "https://github.com/#{username}"
  end

  def socials
    socials = {github: github}

    SOCIALS.each do |social|
      value = send(social)
      socials[social] = value if value
    end

    socials
  end
end
