class AddPlaceToDonation < ActiveRecord::Migration[5.0]
  def change
    add_reference :donations, :place, foreign_key: true
  end
end
