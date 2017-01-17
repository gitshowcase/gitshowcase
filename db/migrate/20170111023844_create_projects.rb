class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :title, null: false
      t.string :homepage
      t.string :repository
      t.string :url
      t.string :description
      t.string :icon
      t.string :cover
      t.string :language
      t.string :manifest
      t.boolean :fork
      t.boolean :hide
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
