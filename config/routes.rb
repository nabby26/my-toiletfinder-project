Rails.application.routes.draw do

  get 'sessions/new'

	root 'home#index'
	get  '/about',    to: 'home#about'
	
	get  '/signup',  to: 'users#new'
	post '/signup',  to: 'users#create'
	get  '/user_settings',        to: 'user#settings'

	get    '/login',   to: 'sessions#new'
  	post   '/login',   to: 'sessions#create'
  	delete '/logout',  to: 'sessions#destroy'

	resources :toilets
	resources :users
end
