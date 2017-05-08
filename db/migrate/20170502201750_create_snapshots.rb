class CreateSnapshots < ActiveRecord::Migration[5.0]
  def change
    create_table :snapshots do |t|
      t.date :date

      # Total values
      t.integer :count_users, null: false, default: 0
      t.integer :count_projects, null: false, default: 0
      t.integer :count_domains, null: false, default: 0
      t.float :total_user_completeness, null: false, default: 0
      t.integer :count_user_weak_completeness, null: false, default: 0
      t.integer :count_user_medium_completeness, null: false, default: 0
      t.integer :count_user_strong_completeness, null: false, default: 0
      t.integer :count_user_very_strong_completeness, null: false, default: 0
      t.integer :count_invitations, null: false, default: 0
      t.integer :count_invitation_rewards, null: false, default: 0
      t.integer :count_zero_invitations, null: false, default: 0
      t.integer :count_one_invitations, null: false, default: 0
      t.integer :count_two_invitations, null: false, default: 0
      t.integer :count_three_invitations, null: false, default: 0
      t.integer :count_four_invitations, null: false, default: 0
      t.integer :count_five_invitations, null: false, default: 0
      t.integer :count_six_more_invitations, null: false, default: 0

      # Daily values
      t.integer :daily_count_users, null: false, default: 0
      t.integer :daily_count_projects, null: false, default: 0
      t.integer :daily_count_domains, null: false, default: 0
      t.float :daily_total_user_completeness, null: false, default: 0
      t.integer :daily_count_user_weak_completeness, null: false, default: 0
      t.integer :daily_count_user_medium_completeness, null: false, default: 0
      t.integer :daily_count_user_strong_completeness, null: false, default: 0
      t.integer :daily_count_user_very_strong_completeness, null: false, default: 0
      t.integer :daily_count_invitations, null: false, default: 0

      t.timestamps

      t.index :date, unique: true
    end
  end
end
