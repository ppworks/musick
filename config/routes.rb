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
  
  namespace :user do
    get '/' => 'home#index', :as => :home
  end
  
  get 'external/share/:kind' => 'external#share', :as => :external_share
  
  root :to => 'home#index'
end
