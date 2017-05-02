class AddIndexToCities < ActiveRecord::Migration[5.0]
  def up
    add_earthdistance_index :cities, lat: 'latitude', lng: 'longitude'
  end

  def down
    remove_earthdistance_index :cities
  end
end
