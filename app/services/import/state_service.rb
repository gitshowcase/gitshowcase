class Import::StateService < ImportService
  def import
    countries = Hash[Country.all.map { |country| [country.abbreviation, country.id] }]

    states = yaml_records.map do |record|
      {
          abbreviation: record['abbreviation'],
          name: record['name'],
          country_id: countries[record['country']]
      }
    end

    # Mass import
    State.import states, on_duplicate_key_update: {conflict_target: [:abbreviation, :country_id], columns: [:name]}, validate: false
  end

  def export
    fields = :abbreviation, :name, 'countries.abbreviation as country'
    data = State.order(:name).joins(:country).select fields
    export_yaml data
  end

  protected

  def self.filename
    'states'
  end
end
