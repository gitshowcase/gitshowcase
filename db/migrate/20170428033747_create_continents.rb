class CreateContinents < ActiveRecord::Migration[5.0]
  def change
    create_table :continents do |t|
      t.string :abbreviation, null: false
      t.string :name, null: false

      t.timestamps
    end
  end
end
