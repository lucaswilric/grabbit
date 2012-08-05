Grabbit3::Application.routes.draw do

  resources :download_jobs do
    post 'search', :on => :collection
  end

  resources :subscriptions do
    resources :download_jobs
  end
  
  resources :resources
  
  resources :tags
  
  match 'download_jobs/tagged/:tag_name/' => 'download_jobs#index'
  match 'subscriptions/tagged/:tag_name/' => 'subscriptions#index'
  
  match 'download_jobs/tagged/:tag_name/feed' => 'download_jobs#feed'

  # OmniAuth login routes
  get   '/login', :to => 'sessions#new', :as => :login
  match '/auth/:provider/callback', :to => 'sessions#create'
  match '/auth/failure', :to => 'sessions#failure'
  get   '/logout', :to => 'sessions#destroy'
  
  get "home/index"

  root :to => 'home#index'
end
