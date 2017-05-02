class Import::ContinentService < ImportService
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
    yaml_records.each do |record|
      Continent.find_or_create_by(abbreviation: record['abbreviation']) do |continent|
        continent.name = record['name']
      end
    end
  end

  def export
    export_yaml Continent.order(:name).select(:abbreviation, :name)
  end

  protected

  def self.filename
    'continents'
  end
end
