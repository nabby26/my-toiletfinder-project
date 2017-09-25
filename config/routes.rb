Rails.application.routes.draw do

	root 'home#index'
	get  '/help',    to: 'home#help'
	get  '/signup',  to: 'users#new'

	resources :toilets
end
