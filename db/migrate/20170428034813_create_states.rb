class CreateStates < ActiveRecord::Migration[5.0]
  def change
    create_table :states do |t|
      t.references :country, foreign_key: true, null: false
      t.string :abbreviation, null: false
      t.string :name

      t.timestamps
      t.index [:abbreviation, :country_id], unique: true
    end
  end
end
