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
    get '/:artist_id/images' => 'images#index', :as => :images
    get '/:artist_id/items/page/:page' => 'items#index', :as => :items
    get '/:artist_id/items' => 'items#index', :as => :items
  end
  
  namespace :social do
    resource :posts, :only => [:new, :create]
    get 'friends/(:provider)' => 'friends#index', :constraint => {:provider => /facebook|twitter|mixi/}, :as => :friends
    post 'friends/invite/(:provider)' => 'friends#invite', :constraint => {:provider => /facebook|twitter|mixi/}, :as => :invite_friends
  end
  
  namespace :users do
    post 'artists/:id/add' => 'artists#create', :constraint => {:id => /[0-9]+/}, :as => :create_artist
    delete 'artists/:id/remove' => 'artists#destroy', :constraint => {:id => /[0-9]+/}, :as => :destroy_artist
    get ':user_id/artists/page/:page' => 'artists#index', :constraint => {:user_id => /[0-9]+/}, :as => :artists
    get ':user_id/artists' => 'artists#index', :constraint => {:user_id => /[0-9]+/}, :as => :artists
  end
  
  get 'login' => 'home#login', :as => :login
  root :to => 'home#index'
end
