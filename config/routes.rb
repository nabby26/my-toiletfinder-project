Rails.application.routes.draw do

	root 'home#index'
	get  '/about',    to: 'home#about'
	
	get  '/signup',  to: 'users#new'
	post '/signup',  to: 'users#create'
	get  '/profile', to: 'users#show'
	get  '/settings',	to: 'users#settings'
	delete '/delete_account', to: 'users#destroy'

	get    '/login',   to: 'sessions#new'
  	post   '/login',   to: 'sessions#create'
  	delete '/logout',  to: 'sessions#destroy'

  	get		'/toilets', to: 'toilets#index'

  	get 	'/feedback', to: 'feedbacks#new'
  	post 	'/feedback', to: 'feedbacks#create'

	resources :toilets
	resources :users
	resources :feedbacks
end
