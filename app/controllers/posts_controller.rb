class PostsController < ApplicationController
	before_action :authenticate_user!, only: [:edit, :new, :show, :create, :index]
  before_action :correct_user, only: [:update, :edit]

  def top
    @favorite_ranks = Post.create_favorite_ranks
    @relationship_ranks = Post.create_relationship_ranks
  end


  def index
  	@posts = Post.all.order(created_at: :desc)
    @post = Post.new
    @user = current_user
    @posts = @posts.where('title LIKE ? OR body LIKE ?', "%#{params[:search]}%", "%#{params[:search]}%") if params[:search].present?
  end

  def edit
    @post = Post.find(params[:id])
  end

  def show
  	@post = Post.find(params[:id])
  	@user = @post.user
    @post_comment = PostComment.new
    @relationship = current_user.relationships.find_by(follow_id: @user.id)
    @set_relationship = current_user.relationships.new
  end

  def new
  	@post = Post.new
  end

  def create
  	@post = Post.all
  	@post = Post.new(post_params)
  	@post.user = current_user
  	if @post.save
      tags = Vision.get_image_data(@post.post_image)
      tags.each do |tag|
        @post.tags.create(name: tag)
      end
  	  redirect_to post_path(@post)
    else
      render :new
    end
  end

  def update
    @user = current_user
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post)
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @user = current_user
    @post.destroy
    redirect_to user_path(@user)
  end

  private
  def post_params
    params.require(:post).permit(:title, :body, :post_image, :user_id)
  end

  def correct_user
    post = Post.find(params[:id])
    if current_user != post.user
      redirect_to root_path
    end
  end

end
