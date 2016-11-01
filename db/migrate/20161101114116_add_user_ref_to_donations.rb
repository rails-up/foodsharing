class AddUserRefToDonations < ActiveRecord::Migration[5.0]
  def change
    add_reference :donations, :user, index: true, foreign_key: true
  end
end
