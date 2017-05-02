class CreateCountries < ActiveRecord::Migration[5.0]
  def change
    create_table :countries do |t|
      t.references :continent, foreign_key: true, null: false
      t.string :abbreviation, null: false
      t.string :name, null: false

      t.timestamps
      t.index :name, using: :gin
      t.index :abbreviation, unique: true
    end
  end
end
