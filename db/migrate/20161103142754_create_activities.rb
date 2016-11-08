class CreateActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :activities do |t|
      t.references :user, foreign_key: true
      t.string :recipient
      t.string :action
      t.references :donation, foreign_key: true

      t.timestamps
    end
  end
end
