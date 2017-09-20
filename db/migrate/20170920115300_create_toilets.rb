class CreateToilets < ActiveRecord::Migration[5.0]
  def change
    create_table :toilets do |t|
      t.string :title
      t.string :location
      t.string :description

      t.timestamps
    end
  end
end
