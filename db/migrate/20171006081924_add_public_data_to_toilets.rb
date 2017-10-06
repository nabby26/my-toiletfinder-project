class AddPublicDataToToilets < ActiveRecord::Migration[5.0]
  def change
  	add_column :toilets, :public_data, :boolean, :default => false
  end
end
