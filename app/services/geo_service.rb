class GeoService < ApplicationService
  def self.import
    instances.map(&:import)
  end

  def self.export
    instances.map(&:export)
  end

  private

  def self.instances
    @instances ||= [
        Import::ContinentService,
        Import::CountryService,
        Import::StateService,
        Import::TimezoneService,
        Import::CityService
    ].map(&:new)
  end
end
