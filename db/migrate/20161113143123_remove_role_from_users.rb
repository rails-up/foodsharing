class RemoveRoleFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :role, :integer
  end
end
