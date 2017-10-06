class AddColumnsToToilets < ActiveRecord::Migration[5.0]
  def change
  	add_column :toilets, :female, :boolean, :default => false
    add_column :toilets, :male, :boolean, :default => false
    add_column :toilets, :lon, :float, :default => nil
    add_column :toilets, :lat, :float, :default => nil
  end
end
