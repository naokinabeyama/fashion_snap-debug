class AddPostIdToFavorites < ActiveRecord::Migration[5.2]
  def change
    add_column :favorites, :post_id, :integer
  end
end
