# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets fol
# der are already added.
Rails.application.config.assets.precompile += %w( admin.js admin.css )
Rails.application.config.assets.precompile += %w( dashboard.js dashboard.css )
Rails.application.config.assets.precompile += %w( landing.js landing.css )
Rails.application.config.assets.precompile += %w( pages.js pages.css )
Rails.application.config.assets.precompile += %w( profile.js profile.css )
Rails.application.config.assets.precompile += %w( setup.js setup.css )

Rails.application.config.assets.precompile += %w( themes/classic.js themes/classic.css )
