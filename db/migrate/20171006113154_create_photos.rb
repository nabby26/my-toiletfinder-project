class CreatePhotos < ActiveRecord::Migration[5.0]
  def change
    create_table :photos do |t|
      t.string :caption
      t.string :photo_url
      t.integer :user_id
      t.integer :toilet_id

      t.timestamps
    end
  end
end
