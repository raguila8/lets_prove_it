Rails.application.routes.draw do

  resources :comments, only: [:new, :edit, :create, :update, :destroy]

  get '/comments/:id/cancel_edit_comment', to: 'comments#cancel_edit', as: :cancel_edit_comment
  get '/proofs/:id/cancel_new_comment', to: 'proofs#cancel_new', as: :cancel_new_comment


  resources :topics

  get '/topics/:id/problems', to: 'topics#problems', as: :topic_problems
  get '/topics/:id/users', to: 'topics#users', as: :topic_users
  get '/topics/:id/logs', to: 'topics#logs', as: :topic_logs

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
  resources :users, only: [:show, :index]
  resources :problems
  get '/problems/:id/logs', to: 'problems#logs', as: :problem_logs
  resources :images, only: [:create, :destroy]
  put '/vote', to: 'users#vote', as: :vote

  post '/problems/:id/follow', to: 'problems#follow', as: :problem_follow
	delete '/problems/:id/unfollow', to: 'problems#unfollow', as: :problem_unfollow

  post '/topics/:id/follow', to: 'topics#follow', as: :topic_follow
	delete '/topics/:id/unfollow', to: 'topics#unfollow', as: :topic_unfollow

  resources :conversations do
    resources :messages
  end

  post '/conversations/:id/mark_as_read', to: 'conversations#mark_as_read', as: :mark_as_read_message
  post '/conversations/mark_all_as_read', to: 'conversations#mark_all_as_read', as: :mark_all_as_read_messages
 
  resources :notifications, only: [:index, :destroy] do
    collection do
      post :mark_all_as_read
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
