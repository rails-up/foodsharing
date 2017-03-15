class AddPickUpDateToDonations < ActiveRecord::Migration[5.0]
  def change
    add_column :donations, :pick_up_date, :datetime
  end
end
