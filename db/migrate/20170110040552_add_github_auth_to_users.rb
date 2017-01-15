class AddGithubAuthToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :github_uid, :string
    add_column :users, :github_token, :string
  end
end
