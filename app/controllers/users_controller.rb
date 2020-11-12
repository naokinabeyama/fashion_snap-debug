class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :index, :show]
  before_action :ensure_correct_user, only: [:update, :edit]

  def index
    @users = User.all.order(created_at: :desc)
    @users = @users.where('name LIKE ? OR introduction LIKE ?', "%#{params[:search]}%","%#{params[:search]}%") if params[:search].present?
    @relationship = current_user.relationships.find_by(follow_id: @users.ids)
    @set_relationship = current_user.relationships.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc)
    @post = Post.new
    @relationship = current_user.relationships.find_by(follow_id: @user.id)
    @set_relationship = current_user.relationships.new
  end

  def followings
    @user = User.find(params[:follow_id])
    @users = @user.followings.all.order(created_at: :desc)
    @relationship = current_user.relationships.find_by(follow_id: @user.id)
    @set_relationship = current_user.relationships.new
  end

  def followers
    @user = User.find(params[:follow_id])
    @users = @user.followers.all.order(created_at: :desc)
    @relationship = current_user.relationships.find_by(follow_id: @user.id)
    @set_relationship = current_user.relationships.new
  end

  def create
    @users = User.all
    @user = User.new(user_params)
    if @user.save
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :profile_image, :introduction, :gender)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to root_path
    end
  end
end
