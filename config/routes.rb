Rails.application.routes.draw do
  get 'comments/create'

  get 'comments/edit'

  get 'comments/update'

  resources :proofs
  get '/proofs/:id/cancel_edit', to: 'proofs#cancel_edit', as: :cancel_edit
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
  resources :images, only: [:create, :destroy]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
