class AddSyncingFieldToProject < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :syncing, :boolean
  end
end
