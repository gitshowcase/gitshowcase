class Import::StateService < ImportService
  FILENAME = 'states'

  def import
    countries = Hash[Country.all.map { |country| [country.abbreviation, country.id] }]

    records = YAML.load_file(path(FILENAME))
    states = records.map do |record|
      State.new(
          abbreviation: record['abbreviation'],
          name: record['name'],
          country_id: countries[record['country']]
      )
    end

    # Mass import
    State.import states, on_duplicate_key_update: {conflict_target: [:abbreviation, :country_id], columns: [:name]}
  end

  def export
    fields = :abbreviation, :name, 'countries.abbreviation as country'
    data = State.order(:name).joins(:country).select fields
    export_yaml(FILENAME, data)
  end
end
