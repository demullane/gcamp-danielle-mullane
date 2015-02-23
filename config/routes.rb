Rails.application.routes.draw do

  resources :tasks
  resources :users
  resources :projects

  root 'welcome#index'
    get '/about' => 'about#index'
    get '/terms' => 'terms#index'
    get '/faq' => 'faq#index'
    get '/tasks' => 'tasks#index'
    get '/users' => 'users#index'
    get '/projects' => 'projects#index'

    get '/signup' => 'registrations#new'
    post '/signup' => 'registrations#create'

    get '/signin' => 'sessions#new'
    post '/signin' => 'sessions#create'

    get '/signout' => 'sessions#destroy'

end
