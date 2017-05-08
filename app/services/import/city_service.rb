class Import::CityService < ImportService
  def import
    countries = Hash[Country.select(:id, :abbreviation).map { |country| [country.abbreviation, country.id] }]
    timezones = Hash[Timezone.select(:id, :slug).map { |timezone| [timezone.slug, timezone.id] }]

    states_result = State.select(:id, :abbreviation, 'countries.abbreviation as country_abbreviation').joins(:country).map do |state|
      ["#{state.country_abbreviation}:#{state.abbreviation}", state.id]
    end

    states = Hash[states_result]

    cities = yaml_records.map do |record|
      country = record['country']

      {
          key: record['key'],
          name: record['name'],
          full_name: record['full_name'],
          latitude: record['latitude'],
          longitude: record['longitude'],
          population: record['population'],
          capital: record['capital'],
          country_id: countries[country],
          timezone_id: timezones[record['timezone']],
          state_id: record['state'].present? ? states["#{country}:#{record['state']}"] : nil
      }
    end

    columns = [:name, :full_name, :latitude, :longitude, :population, :capital, :country_id, :timezone_id, :state_id]
    City.import cities, on_duplicate_key_update: {conflict_target: [:key], columns: columns}, validate: false
  end

  def export
    fields = :name, :key, :full_name, :latitude, :longitude, :population, :capital,
        'states.abbreviation as state', 'countries.abbreviation as country', 'timezones.slug as timezone'
    data = City.order(:name).joins(:country).left_joins(:state).left_joins(:timezone).select fields
    export_yaml data
  end

  protected

  def self.filename
    'cities'
  end
end
