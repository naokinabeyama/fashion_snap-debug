Rails.application.routes.draw do
  get '/home/about' => 'home#about'
  get 'users/followings/:follow_id' => 'users#followings',as: 'user_followings'
  get 'users/followers/:follow_id' => 'users#followers',as: 'user_followers'
  devise_for :users
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#new_guest'
  end
  root 'posts#top'
  resources :users, only: [:index, :show, :new, :edit, :create, :update, :new]
  resources :posts, only: [:index, :show, :new, :edit, :create, :update, :destroy] do
  	resource :favorites, only: [:create, :destroy]
  	resources :post_comments, only: [:create, :destroy]
  end
  resources :relationships, only: [:create, :destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
