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
  end
  
  namespace :social do
    resource :posts, :only => [:new, :create]
    get 'friends/(:provider)' => 'friends#index', :constraint => {:provider => /facebook|twitter|mixi/}, :as => :friends
    post 'friends/invite/(:provider)' => 'friends#invite', :constraint => {:provider => /facebook|twitter|mixi/}, :as => :invite_friends
  end
  
  namespace :user do
    post 'artists/:id/follow' => 'artists#follow', :constraint => {:id => /[0-9]+/}, :as => :follow_artist
    delete 'artists/:id/unfollow' => 'artists#unfollow', :constraint => {:id => /[0-9]+/}, :as => :unfollow_artist
  end
  
  get 'login' => 'home#login', :as => :login
  root :to => 'home#index'
end
