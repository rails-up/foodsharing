class CreateCities < ActiveRecord::Migration[5.0]
  def up
    create_table :cities do |t|
      t.string :name

      t.timestamps
    end

    add_column :donations, :city_id, :integer
  end

  def down
    drop_table :cities
    remove_column :donations, :city_id
  end
end
