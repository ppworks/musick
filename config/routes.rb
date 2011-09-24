Musick::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }, :skip => [:sessions]
  devise_scope :user do
    match '/users/sign_out(.:format)', {:action=>"destroy", :controller=>"devise/sessions", :via => :delete, :as => :destroy_user_session }
    match '/(.:format)', {:action=>"index", :controller=>"home", :via => :get, :as => :new_user_session }
  end

  resources :artists, :only => [:index, :show] do
    get 'page/:page', :action => :index, :on => :collection
    get 'search', :action => :search, :on => :collection
    get 'search_lastfm', :action => :search_lastfm, :on => :collection
  end
  
  namespace :artist do
    get '/:artist_id/images' => 'images#index', :constraint => {"artist_id" => /[0-9]+/}, :as => :images
    get '/:artist_id/items/page/:page' => 'items#index', :constraint => {"artist_id" => /[0-9]+/, "page" => /[0-9]+/}, :as => :items
    get '/:artist_id/items' => 'items#index', :constraint => {"artist_id" => /[0-9]+/}, :as => :items
    get '/:artist_id/items/:item_asin' => 'items#show', :constraint => {"artist_id" => /[0-9]+/}, :as => :item
  end
  
  namespace :social do
    resource :posts, :only => [:new, :create]
    get 'posts/new_with_action' => 'posts#new_with_action', :as => :new_posts_with_action
    post 'posts/create_with_action' => 'posts#create_with_action', :as => :create_posts_with_action
    get 'friends/(:provider)' => 'friends#index', :constraint => {"provider" => /facebook|twitter|mixi/}, :as => :friends
    post 'friends/invite/(:provider)' => 'friends#invite', :constraint => {"provider" => /facebook|twitter|mixi/}, :as => :invite_friends
  end
  
  namespace :users do
    post 'artists/:id' => 'artists#create', :constraint => {"id" => /[0-9]+/}, :as => :create_artist
    delete 'artists/:id' => 'artists#destroy', :constraint => {"id" => /[0-9]+/}, :as => :destroy_artist
    get ':user_id/artists/page/:page' => 'artists#index', :constraint => {"user_id" => /[0-9]+/}, :as => :artists
    get ':user_id/artists' => 'artists#index', :constraint => {"user_id" => /[0-9]+/}, :as => :artists
    get ':user_id/friends' => 'friends#index', :constraint => {"user_id" => /[0-9]+/}, :as => :friends
    post 'artists/:artist_id/items/:item_asin' => 'artist_items#create', :constraint => {"artist_id" => /[0-9]+/}, :as => :create_artist_item
    delete 'artists/:artist_id/items/:item_asin' => 'artist_items#destroy', :constraint => {"artist_id" => /[0-9]+/}, :as => :destroy_artist_item
    get ':user_id/artist_items/page/:page' => 'artist_items#index', :constraint => {"user_id" => /[0-9]+/, "page" => /[0-9]+/}, :as => :artist_items
    get ':user_id/artist_items' => 'artist_items#index', :constraint => {"user_id" => /[0-9]+/}, :as => :artist_items
    post 'artists/:artist_id/items/:item_asin/discs/:disc/tracks/:track' => 'artist_tracks#create', :constraint => {"artist_id" => /[0-9]+/, "disc" => /[0-9]+/, "track" => /[0-9]+/}, :as => :create_artist_track
    delete 'artists/:artist_id/items/:item_asin/discs/:disc/tracks/:track' => 'artist_tracks#destroy', :constraint => {"artist_id" => /[0-9]+/, "disc" => /[0-9]+/, "track" => /[0-9]+/}, :as => :destroy_artist_track
    get ':user_id/artist_tracks/page/:page' => 'artist_tracks#index', :constraint => {"user_id" => /[0-9]+/, "page" => /[0-9]+/}, :as => :artist_tracks
    get ':user_id/artist_tracks' => 'artist_tracks#index', :constraint => {"user_id" => /[0-9]+/}, :as => :artist_tracks
  end
  
  get 'login' => 'home#login', :as => :login
  root :to => 'home#index'
end
