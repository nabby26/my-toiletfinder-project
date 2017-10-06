class AddFacilitiesToToilets < ActiveRecord::Migration[5.0]
  def change
    add_column :toilets, :parentsRoom, :boolean, :default => false
    add_column :toilets, :gender_neutral, :boolean, :default => false
    add_column :toilets, :disabled_opt, :boolean, :default => false
  end
end
