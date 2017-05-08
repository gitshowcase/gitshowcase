source 'https://rubygems.org'

# Use ruby 2.4.0
ruby '2.4.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'

# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'

# Use Puma as the app server
gem 'puma', '~> 3.0'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets

gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'

# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

source 'https://rails-assets.org' do
  # Add Tether because bootstrap needs it
  gem 'rails-assets-tether'

  # Use Bootstrap to make it pretty
  gem 'rails-assets-bootstrap', '~> 4.0.0.alpha.6'

  # Use WOW and animate.css for cool animations
  gem 'rails-assets-animate.css'
  gem 'rails-assets-wow'

  # Use countUp to animate number of projects created
  gem 'rails-assets-countup'

  # Use Clipboard for copying text to clipboard
  gem 'rails-assets-clipboard'
end

# Use sortable to allow sorting projects and skills
gem 'sortable-rails'

# Use TypeAhead for autocompletion
gem 'bootstrap-typeahead-rails'

# Use font awesome for icons
gem 'font-awesome-rails'

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Octokit to consume GitHub API
gem 'octokit', '~> 4.0'

# Use Devise for authentication
gem 'devise'

# Use SimpleForm to facilitate form creation
gem 'simple_form'

# Omniauth authentication
gem 'omniauth'
gem 'omniauth-github'

# Use metainspector to fetch project meta information
gem 'metainspector'

# Use xml-sitemap to create sitemap strings
gem 'xml-sitemap'

# Add SLIM markup
gem 'slim-rails'

# Use Gibbon as MailChimp API wrapper
gem 'gibbon'

# Use Heroku Platform API to register domains
gem 'platform-api'

# Use Sidekiq for background jobs
gem 'sidekiq'

# Use GoogleAPI for analytics
# gem 'google-api-client', '~> 0.10'

# Use WillPaginate for pagination
gem 'will_paginate'
gem 'will_paginate-bootstrap'

# Use HTTP to handle pontual requests
gem 'http'

# Use GeoCoder for geolocation
gem 'geocoder'

# Use EarthDistance to find nearby places
gem 'activerecord-postgres-earthdistance'

# Use PG_Search to autocomplete location
gem 'pg_search'

# User ActiveRecordImport for mass import
gem 'activerecord-import'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri

  # Add pry-byebug to enable pry features like navigation for byebug
  gem 'pry-byebug'

  # Use FactoryGirl to use factories
  gem 'factory_girl_rails'

  # Use rspec for testing
  gem 'rspec-rails', '~> 3.5'

  # Use simplecov for code coverage
  gem 'simplecov', require: false

  # Use shoulda to facilitate testing
  gem 'shoulda-matchers', '~> 3.1', require: false

  # Use VCR for recording HTTP requests
  gem 'vcr'

  # Use WebMock as HTTP interceptor
  gem 'webmock'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '~> 3.0.5'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  # Use CityState for a list of cities/states/countries
  gem 'city-state'

  # Call ap for a readable result
  gem 'awesome_print', require: 'ap'

  # Use meta request for Rails Panel
  gem 'meta_request'

  # Use dotenv to configure environment variables
  gem 'dotenv-rails'

  # Use faker to generate seeds
  gem 'faker'
end

group :production do
  # Use TunyeMyGC for GC insights
  gem 'tunemygc'

  # Choose monitoring app
  gem 'scout_apm'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Windows dones't detect file changes by default
gem 'wdm', '>= 0.1.0' if Gem.win_platform?
