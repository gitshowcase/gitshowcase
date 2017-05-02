class Import::ContinentService < ImportService
  FILENAME = 'continents'

  CONTINENTS = {
      AF: 'Africa',
      AS: 'Asia',
      EU: 'Europe',
      NA: 'North America',
      OC: 'Oceania',
      SA: 'South America',
      AN: 'Antarctica'
  }

  def import
    records = YAML.load_file(path(FILENAME))
    records.each do |record|
      Continent.find_or_create_by(abbreviation: record['abbreviation']) do |continent|
        continent.name = record['name']
      end
    end
  end

  def export
    export_yaml(FILENAME, Continent.order(:name).select(:abbreviation, :name))
  end
end
