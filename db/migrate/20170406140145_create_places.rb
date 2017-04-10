class CreatePlaces < ActiveRecord::Migration[5.0]
  def change
    create_table   :places do |t|
      t.string     :name
      t.string     :address
      t.float      :lat
      t.float      :lng
      t.string     :line
      t.references :city, foreign_key: true

      t.timestamps
    end
  end
end
