class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :title
      t.string :homepage
      t.string :repository
      t.string :url
      t.string :description
      t.string :icon
      t.string :cover
      t.string :language
      t.boolean :hide
      t.boolean :has_manifest
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
