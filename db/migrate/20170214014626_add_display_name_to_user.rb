class AddDisplayNameToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :display_email, :string
  end
end
