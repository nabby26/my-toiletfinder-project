class AddImageUrlToToilets < ActiveRecord::Migration[5.0]
  def change
    add_column :toilets, :image_url, :string
  end
end
