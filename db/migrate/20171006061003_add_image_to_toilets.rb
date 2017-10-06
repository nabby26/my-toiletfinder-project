class AddImageToToilets < ActiveRecord::Migration[5.0]
  def change
    add_column :toilets, :image, :string
  end
end
