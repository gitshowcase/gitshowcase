class AddInfoToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :name, :string
    add_column :users, :username, :string
    add_column :users, :image, :string
    add_column :users, :bio, :string
    add_column :users, :is_available_for_hire, :bool

    add_column :users, :linkedin, :string
    add_column :users, :angel_list, :string
    add_column :users, :facebook, :string
    add_column :users, :twitter, :string
    add_column :users, :stack_overflow, :string
    add_column :users, :medium, :string
    add_column :users, :blog, :string
  end
end
