class AddCompletenessToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :completeness, :float, null: false, default: 0
    add_column :users, :completeness_details, :json
  end
end
