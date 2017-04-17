module SocialNetworks
  extend ActiveSupport::Concern

  SOCIALS = {
      # Networking
      linkedin: {
          prefix: 'linkedin.com/in',
          type: :networking
      },
      angellist: {
          prefix: 'angel.co',
          type: :networking
      },
      twitter: {
          prefix: 'twitter.com',
          type: :networking
      },
      facebook: {
          prefix: 'facebook.com',
          type: :networking
      },
      google_plus: {
          prefix: 'plus.google.com',
          type: :networking
      },

      # Development
      stack_overflow: {
          prefix: 'stackoverflow.com/users',
          type: :development
      },
      codepen: {
          prefix: 'codepen.io',
          type: :development
      },
      jsfiddle: {
          prefix: 'jsfiddle.net',
          type: :development
      },

      # Writing
      medium: {
          prefix: 'medium.com',
          type: :writing
      },
      blog: {
          type: :writing,
          protocol: 'http'
      },

      # Design
      behance: {
          prefix: 'behance.net',
          type: :design
      },
      dribbble: {
          prefix: 'dribbble.com',
          type: :design
      },
      pinterest: {
          prefix: 'pinterest.com',
          type: :design
      }
  }

  included do
    # Create getters and setters
    SOCIALS.each do |social, properties|
      define_method "#{social}" do
        UrlHelper.website_url(properties[:prefix], self[social], properties[:protocol] || 'https')
      end

      define_method "#{social}=" do |val|
        val = UrlHelper.extract(val, "#{properties[:prefix]}/") if properties.key?(:prefix)
        self[social] = val
      end
    end
  end

  def github
    "https://github.com/#{username}"
  end

  def socials
    socials = {github: github}

    SOCIALS.each do |social, _|
      value = send(social)
      socials[social] = value if value
    end

    socials
  end
end
