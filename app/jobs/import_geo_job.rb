class ImportGeoJob < ApplicationJob
  queue_as :default

  def perform
    GeoService.import
  end
end
