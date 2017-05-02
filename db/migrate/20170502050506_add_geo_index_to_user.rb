class AddGeoIndexToUser < ActiveRecord::Migration[5.0]
  def up
    add_earthdistance_index :users, lat: 'latitude', lng: 'longitude'
  end

  def down
    remove_earthdistance_index :users
  end
end
