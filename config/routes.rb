Musick::Application.routes.draw do
  get "user_voices/create"

  get 'artists/page/:page' => 'artists#index', :as => :artists
  get 'artists' => 'artists#index', :as => :artists
  get 'artists/search' => 'artists#search', :as => :search_artists
  get 'artists/search_lastfm' => 'artists#search_lastfm', :as => :search_lastfm_artists
  get 'artists/:id' => 'artists#show_redirect'
  get 'artist/:id' => 'artists#show', :as => :artist
  
  namespace :artist do
    get '/:artist_id/images' => 'images#index', :constraints => {:artist_id => /[0-9]+/}, :as => :images
    get '/:artist_id/images/:id' => 'images#show', :constraints => {:artist_id => /[0-9]+/, :id => /[0-9]+/}, :as => :image
    get '/:artist_id/items/page/:page' => 'items#index', :constraints => {:artist_id => /[0-9]+/, :page => /[0-9]+/}, :as => :items
    get '/:artist_id/items' => 'items#index', :constraints => {:artist_id => /[0-9]+/}, :as => :items
    get '/:artist_id/items/search/page/:page/' => 'items#search', :constraints => {:artist_id => /[0-9]+/, :page => /[0-9]+/}, :as => :search_items
    get '/:artist_id/items/search/' => 'items#search', :constraints => {:artist_id => /[0-9]+/}, :as => :search_items
    get '/:artist_id/items/:item_asin' => 'items#show', :constraints => {}, :as => :item
    get '/:artist_id/items/:item_asin/discs/:disc/tracks/:track' => 'tracks#show', :constraints => {:disc => /[0-9]+/, :track => /[0-9]+/}, :as => :track
  end
  
  namespace :social do
    resource :posts, :only => [:new, :create]
    get 'posts/new_with_action' => 'posts#new_with_action', :as => :new_posts_with_action
    post 'posts/create_with_action' => 'posts#create_with_action', :as => :posts_with_action
    get 'friends/(:provider)' => 'friends#index', :constraints => {:provider => /facebook|twitter|mixi/}, :as => :friends
    post 'friends/invite/(:provider)' => 'friends#invite', :constraints => {:provider => /facebook|twitter|mixi/}, :as => :invite_friends
  end
  
  namespace :admin do
    get '/users/page/:page' => 'users#index'
    get '/users' => 'users#index'
    post '/users/:id' => 'users#login', :as => :login_as_user
  end
  
  namespace :users do
    post 'artists/:id' => 'artists#create', :constraints => {:id => /[0-9]+/}, :as => :create_artist
    delete 'artists/:id' => 'artists#destroy', :constraints => {:id => /[0-9]+/}, :as => :destroy_artist
    get ':user_id/artists/page/:page' => 'artists#index', :constraints => {:user_id => /[0-9]+/}, :as => :artists
    get ':user_id/artists' => 'artists#index', :constraints => {:user_id => /[0-9]+/}, :as => :artists
    get ':user_id/friends' => 'friends#index', :constraints => {:user_id => /[0-9]+/}, :as => :friends
    post 'artists/:artist_id/items/:item_asin' => 'artist_items#create', :constraints => {:artist_id => /[0-9]+/}, :as => :create_artist_item
    delete 'artists/:artist_id/items/:item_asin' => 'artist_items#destroy', :constraints => {:artist_id => /[0-9]+/}, :as => :destroy_artist_item
    get ':user_id/artist_items/page/:page' => 'artist_items#index', :constraints => {:user_id => /[0-9]+/, :page => /[0-9]+/}, :as => :artist_items
    get ':user_id/artist_items' => 'artist_items#index', :constraints => {:user_id => /[0-9]+/}, :as => :artist_items
    post 'artists/:artist_id/items/:item_asin/discs/:disc/tracks/:track' => 'artist_tracks#create', :constraints => {:artist_id => /[0-9]+/, :disc => /[0-9]+/, :track => /[0-9]+/}, :as => :create_artist_track
    delete 'artists/:artist_id/items/:item_asin/discs/:disc/tracks/:track' => 'artist_tracks#destroy', :constraints => {:artist_id => /[0-9]+/, :disc => /[0-9]+/, :track => /[0-9]+/}, :as => :destroy_artist_track
    get ':user_id/artist_tracks/page/:page' => 'artist_tracks#index', :constraints => {:user_id => /[0-9]+/, :page => /[0-9]+/}, :as => :artist_tracks
    get ':user_id/artist_tracks' => 'artist_tracks#index', :constraints => {:user_id => /[0-9]+/}, :as => :artist_tracks
    get ':user_id/posts/page/:page' => 'posts#index', :constraints => {:user_id => /[0-9]+/}, :as => :posts
    get ':user_id/posts' => 'posts#index', :constraints => {:user_id => /[0-9]+/}, :as => :posts
    get 'faces' => 'faces#index', :as => :faces
    get ':user_id/' => 'home#index', :as => :home
    post 'artists/:artist_id/tags/:tag_id' => 'artists_tags#create', :constraints => {:artist_id => /[0-9]+/, :tag_id => /[0-9]+/}, :as => :create_artists_tag
    delete 'artists/:artist_id/tags/:tag_id' => 'artists_tags#destroy', :constraints => {:artist_id => /[0-9]+/, :tag_id => /[0-9]+/}, :as => :destroy_artists_tag
    post 'artists/:artist_id/items/:item_asin/tags/:tag_id' => 'artist_items_tags#create', :constraints => {:artist_id => /[0-9]+/, :tag_id => /[0-9]+/}, :as => :create_artist_items_tag
    delete 'artists/:artist_id/items/:item_asin/tags/:tag_id' => 'artist_items_tags#destroy', :constraints => {:artist_id => /[0-9]+/, :tag_id => /[0-9]+/}, :as => :destroy_artist_items_tag
    post 'artists/:artist_id/items/:item_asin/discs/:disc/tracks/:track/tags/:tag_id' => 'artist_tracks_tags#create', :constraints => {:artist_id => /[0-9]+/, :tag_id => /[0-9]+/, :disc => /[0-9]+/, :track => /[0-9]+/}, :as => :create_artist_tracks_tag
    delete 'artists/:artist_id/items/:item_asin/discs/:disc/tracks/:track/tags/:tag_id' => 'artist_tracks_tags#destroy', :constraints => {:artist_id => /[0-9]+/, :tag_id => /[0-9]+/, :disc => /[0-9]+/, :track => /[0-9]+/}, :as => :destroy_artist_tracks_tag
  end
  
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }, :skip => [:sessions]
  devise_scope :user do
    match '/users/sign_out(.:format)', {:action=>"destroy", :controller=>"devise/sessions", :via => :delete, :as => :destroy_user_session }
    match '/(.:format)', {:action=>"index", :controller=>"home", :via => :get, :as => :new_user_session }
  end
  
  resources :posts, :only => [:destroy, :show, :index] do
    get 'page/:page', :action => :index, :on => :collection
    post 'sync', :action => :sync, :on => :member, :as => :sync
  end

  namespace :posts do
    get ':id/comments' => 'comments#index', :constraints => {:id => /[0-9]+/}, :as => :comments
    post ':id/comment' => 'comments#create', :constraints => {:id => /[0-9]+/}, :as => :comment
    delete ':id/comments/:comment_id' => 'comments#destroy', :constraints => {:id => /[0-9]+/, :comment_id => /[0-9]+/}, :as => :comments
    get ':id/likes' => 'likes#index', :constraints => {:id => /[0-9]+/}, :as => :likes
    post ':id/like' => 'likes#create', :constraints => {:id => /[0-9]+/}, :as => :like
    delete ':id/like' => 'likes#destroy', :constraints => {:id => /[0-9]+/}, :as => :like
    get ':id/comments/:comment_id/likes' => 'comments_likes#index', :constraints => {:id => /[0-9]+/, :comment_id => /[0-9]+/}, :as => :comments_likes
    post ':id/comments/:comment_id/like' => 'comments_likes#create', :constraints => {:id => /[0-9]+/, :comment_id => /[0-9]+/}, :as => :comments_like
    delete ':id/comments/:comment_id/like' => 'comments_likes#destroy', :constraints => {:id => /[0-9]+/, :comment_id => /[0-9]+/}, :as => :comments_likes
  end

  namespace :providers do
    get ':id/profiles' => 'profiles#index', :as => :profiles
  end
  
  resources :user_voices, :only => [:create]
  
  namespace :stream do
    get 'post/all/(:filters)' => 'post#all', :defaults => {:filters => ''}, :as => :post
    get 'post/artist/(:filters)' => 'post#artist', :defaults => {:filters => ''}, :as => :artist_post
    get 'post/artist_item/(:filters)' => 'post#artist_item', :defaults => {:filters => ''}, :as => :artist_item_post
    get 'post/artist_track/(:filters)' => 'post#artist_track', :defaults => {:filters => ''}, :as => :artist_track_post
    get 'clip/artist/(:filters)' => 'clip#artist', :defaults => {:filters => ''}, :as => :artist_clip
    get 'clip/artist_item/(:filters)' => 'clip#artist_item', :defaults => {:filters => ''}, :as => :artist_item_clip
    get 'clip/artist_track/(:filters)' => 'clip#artist_track', :defaults => {:filters => ''}, :as => :artist_track_clip
  end
  
  get 'about' => 'pages#about', :as => :about_page
  get 'privacy' => 'pages#privacy', :as => :privacy_page
  get 'rule' => 'pages#rule', :as => :rule_page
  get 'gov' => 'pages#gov', :as => :gov_page
  get 'sorry' => 'pages#sorry', :as => :sorry_page
  get 'login' => 'home#login', :as => :login
  root :to => 'home#index'
end
