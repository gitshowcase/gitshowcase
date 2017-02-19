class AddDomainToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :domain, :string

    add_index :users, :domain, unique: true
  end
end
