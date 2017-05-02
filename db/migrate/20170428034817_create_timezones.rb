class CreateTimezones < ActiveRecord::Migration[5.0]
  def change
    create_table :timezones do |t|
      t.references :country, foreign_key: true, null: false
      t.string :slug, null: false
      t.string :name, null: false
      t.integer :offset_1, null: false
      t.integer :offset_2, null: false

      t.timestamps
      t.index :slug, unique: true
    end
  end
end
