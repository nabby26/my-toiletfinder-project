class AddFacilitiesToToilets < ActiveRecord::Migration[5.0]
  def change
    add_column :toilets, :parentsRoom, :boolean
    add_column :toilets, :gender_neutral, :boolean
    add_column :toilets, :disabled_opt, :boolean
  end
end
