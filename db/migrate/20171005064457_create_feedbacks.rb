class CreateFeedbacks < ActiveRecord::Migration[5.0]
  def change
    create_table :feedbacks do |t|
      t.string :comments
      t.integer :overall
      t.integer :cleanliness
      t.integer :odour
      t.integer :safety
      t.integer :wait_time
      t.datetime :check_in
      t.integer :user_id, :limit => 20
      t.integer :toilet_id, :limit => 20


      t.timestamps
    end
  end
end
