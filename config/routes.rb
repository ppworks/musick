Musick::Application.routes.draw do
  resources :artists, :only => [:index, :show] do
    get 'page/:page', :action => :index, :on => :collection
    get 'search', :action => :search, :on => :collection
    get 'search_lastfm', :action => :search_lastfm, :on => :collection
  end
  root :to => 'home#index'
end
