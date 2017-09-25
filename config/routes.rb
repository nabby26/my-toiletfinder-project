Rails.application.routes.draw do

	root 'home#index'
	get  '/help',    to: 'home#help'
	
	get  '/signup',  to: 'users#new'
	post '/signup',  to: 'users#create'

	resources :toilets
	resources :users
end
