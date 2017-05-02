class LocationService < ApplicationService
  def get(value)
    country = Country.where('lower(name) = ?', value).first
    return country unless country.nil?

    city = City.find_by_full_name(value)
    return city unless city.nil?

    value
  end

  def autocomplete(value)
    cities = City.search(value)
    countries = Country.where('lower(name) = ?', value).select(:id, :name).limit(1)

    cities = cities.select(:id, :full_name).limit(4)

    count = cities.count
    if count < 4
      extra_cities = City.loose_search(value).select(:id, :full_name).limit(4 - count)
      extra_cities = extra_cities.where('id NOT IN (?)', cities.map(&:id)) if count > 0

      cities += extra_cities
    end

    {cities: cities, countries: countries}
  end
end
