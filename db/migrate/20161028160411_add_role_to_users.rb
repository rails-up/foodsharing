class AddRoleToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :role, :integer, default: 0
    add_column :articles, :user_id, :integer
  end
end
