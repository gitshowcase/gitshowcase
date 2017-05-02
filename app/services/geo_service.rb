class GeoService < ApplicationService
  def import
    Import::ContinentService.new.import
    Import::CountryService.new.import
    Import::StateService.new.import
    Import::TimezoneService.new.import
    Import::CityService.new.import
  end

  def export
    Import::ContinentService.new.export
    Import::CountryService.new.export
    Import::StateService.new.export
    Import::TimezoneService.new.export
    Import::CityService.new.export
  end
end
