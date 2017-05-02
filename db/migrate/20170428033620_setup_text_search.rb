class SetupTextSearch < ActiveRecord::Migration[5.0]
  def self.up
    execute "CREATE EXTENSION IF NOT EXISTS pg_trgm"
    execute "CREATE EXTENSION IF NOT EXISTS btree_gin"
    execute "CREATE EXTENSION IF NOT EXISTS unaccent"
  end

  def self.down
    execute "DROP EXTENSION IF EXISTS pg_trgm"
    execute "DROP EXTENSION IF EXISTS btree_gin"
    execute "DROP EXTENSION IF EXISTS unaccent"
  end
end
