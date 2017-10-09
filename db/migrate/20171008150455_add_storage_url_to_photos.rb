class AddStorageUrlToPhotos < ActiveRecord::Migration[5.0]
  def change
    add_column :photos, :storage_url, :string
  end
end
