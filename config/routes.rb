Rails.application.routes.draw do

  resources :users
  resources :projects do
    resources :tasks
    resources :memberships
  end

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
