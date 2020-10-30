class RemovePostImageIdFromFavorites < ActiveRecord::Migration[5.2]
  def change
    remove_column :favorites, :post_image_id, :integer
  end
end
