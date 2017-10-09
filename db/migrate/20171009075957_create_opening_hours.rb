class CreateOpeningHours < ActiveRecord::Migration[5.0]
  def change
    create_table :opening_hours do |t|
      t.string :day
      t.integer :open_time
      t.integer :close_time
      t.string :toilet_id

      t.timestamps
    end
  end
end
