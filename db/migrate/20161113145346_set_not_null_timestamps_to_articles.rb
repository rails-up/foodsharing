class SetNotNullTimestampsToArticles < ActiveRecord::Migration[5.0]
  def up
    execute <<-SQL
      UPDATE articles SET created_at = NOW(), updated_at = NOW();
    SQL
    change_column_null :articles, :created_at, false
    change_column_null :articles, :updated_at, false
  end

  def down
    change_column_null :articles, :created_at, true
    change_column_null :articles, :updated_at, true
    execute <<-SQL
      UPDATE articles SET created_at = NULL, updated_at = NULL;
    SQL
  end
end
