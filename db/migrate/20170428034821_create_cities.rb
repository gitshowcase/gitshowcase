class CreateCities < ActiveRecord::Migration[5.0]
  def change
    create_table :cities do |t|
      t.references :state, foreign_key: true
      t.references :country, foreign_key: true, null: false
      t.references :timezone, foreign_key: true, null: false

      t.string :name, null: false
      t.string :key, null: false
      t.string :full_name, null: false
      t.boolean :capital, default: false
      t.integer :population

      t.decimal :latitude, precision: 10, scale: 6, null: false
      t.decimal :longitude, precision: 10, scale: 6, null: false

      t.timestamps

      t.index :full_name, using: :gin
      t.index :key, unique: true
    end
  end
end
