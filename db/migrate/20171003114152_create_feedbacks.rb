class CreateFeedbacks < ActiveRecord::Migration[5.0]
  def change
    create_table :feedbacks do |t|
      t.string :comment
      t.integer :overall
      t.integer :cleanliness
      t.integer :odour
      t.integer :safety
      t.integer :wait_time
      t.datetime :check_in
      t.references :user, foreign_key: true
      t.references :toilet, foreign_key: true

      t.timestamps
    end
  end
end
