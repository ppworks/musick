Musick::Application.routes.draw do
  resources :artists, :only => [:index, :show] do
    get 'page/:page', :action => :index, :on => :collection
    get 'search', :action => :search, :on => :collection
  end
  root :to => 'artists#index'
end
