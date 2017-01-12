class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :title
      t.string :url
      t.string :repository
      t.string :image
      t.string :description
      t.string :language
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
