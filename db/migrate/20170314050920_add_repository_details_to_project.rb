class AddRepositoryDetailsToProject < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :fork, :boolean
    add_column :projects, :stars, :integer
    add_column :projects, :forks, :integer
  end
end
