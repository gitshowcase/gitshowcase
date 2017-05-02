class CreateSetupCovers < ActiveRecord::Migration[5.0]
  def change
    create_table :setup_covers do |t|
      t.string :url, null: false

      t.timestamps
    end
  end
end
