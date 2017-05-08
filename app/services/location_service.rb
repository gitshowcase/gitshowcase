class LocationService < ApplicationService
  def get(location)
    city = City.find_by_full_name(location)
    country_id = city ? city.country.id : Country.where('lower(name) = ?', location).first&.id

    {city_id: city&.id, country_id: country_id, location: location}
  end

  def autocomplete(location)
    cities = City.search(location)
    countries = Country.where('lower(name) = ?', location).select(:id, :name).limit(1)

    cities = cities.select(:id, :full_name).limit(4)

    count = cities.count
    if count < 4
      extra_cities = City.loose_search(location).select(:id, :full_name).limit(4 - count)
      extra_cities = extra_cities.where('id NOT IN (?)', cities.map(&:id)) if count > 0

      cities += extra_cities
    end

    {cities: cities, countries: countries}
  end
end
