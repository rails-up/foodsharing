class AddSpecialToDonations < ActiveRecord::Migration[5.0]
  def change
    add_column :donations, :special, :boolean, default: false, null: false
  end
end
