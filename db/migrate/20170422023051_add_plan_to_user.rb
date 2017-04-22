class AddPlanToUser < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :plans, foreign_key: true, null: true
  end
end
