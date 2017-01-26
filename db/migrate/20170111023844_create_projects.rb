class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :title
      t.string :homepage
      t.string :repository
      t.string :description
      t.string :thumbnail
      t.string :language
      t.integer :position
      t.boolean :hide
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
