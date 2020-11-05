class Post < ApplicationRecord

	belongs_to :user
	attachment :post_image
	has_many :post_comments, dependent: :destroy
	has_many :favorites, dependent: :destroy

	def favorited_by?(user)
    	favorites.where(user_id: user.id).exists?
  	end

  	def self.create_favorite_ranks
  		Post.find(Favorite.group(:post_id).order('count(post_id) desc').limit(3).pluck(:post_id))
  	end

  	def self.create_relationship_ranks
  		User.find(Relationship.group(:follow_id).order('count(follow_id) desc').limit(3).pluck(:follow_id))
  	end
end
