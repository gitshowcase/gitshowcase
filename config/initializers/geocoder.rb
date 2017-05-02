if ENV['BING_GEOCODE_KEY'].present?
  Geocoder.configure(
      lookup: :bing,
      api_key: ENV['BING_GEOCODE_KEY'],
  )
end
