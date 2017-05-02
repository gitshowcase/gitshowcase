class AddGeoToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :latitude, :decimal, precision: 10, scale: 6
    add_column :users, :longitude, :decimal, precision: 10, scale: 6

    add_reference :users, :city, foreign_key: true
    add_reference :users, :country, foreign_key: true
  end
end
