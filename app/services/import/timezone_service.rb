class Import::TimezoneService < ImportService
  FILENAME = 'timezones'

  def import
    countries = Hash[Country.all.map { |country| [country.abbreviation, country.id] }]

    records = YAML.load_file(path(FILENAME))
    timezones = records.map do |record|
      Timezone.new(
          slug: record['slug'],
          name: record['name'],
          offset_1: record['offset_1'],
          offset_2: record['offset_2'],
          country_id: countries[record['country']]
      )
    end

    # Mass import
    Timezone.import timezones, on_duplicate_key_update: {conflict_target: [:slug], columns: [:slug, :offset_1, :offset_2, :country_id]}
  end

  def export
    fields = :slug, :name, :offset_1, :offset_2, 'countries.abbreviation as country'
    data = Timezone.order(:slug).joins(:country).select fields
    export_yaml(FILENAME, data)
  end
end
