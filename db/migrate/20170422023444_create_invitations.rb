class CreateInvitations < ActiveRecord::Migration[5.0]
  def change
    create_table :invitations do |t|
      t.references :inviter, foreign_key: {on_delete: :cascade, to_table: :users}
      t.string :invitee

      t.timestamps
    end
  end
end
