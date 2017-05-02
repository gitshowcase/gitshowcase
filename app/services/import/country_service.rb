class Import::CountryService < ImportService
  FILENAME = 'countries'

  def import
    continents = Hash[Continent.select(:id, :abbreviation).map { |continent| [continent.abbreviation, continent.id] }]

    records = YAML.load_file(path(FILENAME))
    countries = records.map do |record|
      Country.new(
          abbreviation: record['abbreviation'],
          name: record['name'],
          continent_id: continents[record['continent']]
      )
    end

    # Mass import
    Country.import countries, on_duplicate_key_update: {conflict_target: [:abbreviation], columns: [:name, :continent_id]}
  end

  def export
    fields = :abbreviation, :name, 'continents.abbreviation as continent'
    data = Country.order(:name).joins(:continent).select fields
    export_yaml(FILENAME, data)
  end
end
