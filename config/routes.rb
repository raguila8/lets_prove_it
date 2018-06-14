Rails.application.routes.draw do
  resources :proofs
  get 'users/show'

  get 'static_pages/landing'

  get 'static_pages/about'

  devise_for :users, controllers: { registrations: "registrations", sessions: "sessions" }
  devise_scope :user do
    authenticated :user do
			root 'problems#index'
		end
		
		unauthenticated do
			root 'static_pages#landing'
		end
  end
  resources :users, only: [:show]
  resources :problems

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
