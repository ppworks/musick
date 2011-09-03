Musick::Application.routes.draw do
  
  get 'artists/page/:page' => 'artists#index'
  get "artists/index"
  root :to => 'artists#index'
end
