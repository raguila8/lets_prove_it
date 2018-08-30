Rails.application.routes.draw do

  resources :comments, only: [:new, :edit, :create, :update, :destroy]

  get '/comments/:id/cancel_edit_comment', to: 'comments#cancel_edit', as: :cancel_edit_comment
  get '/proofs/:id/cancel_new_comment', to: 'proofs#cancel_new', as: :cancel_new_comment


  resources :topics do
    member do
      get :problems
      get :proofs
      get :followers
      get :log
      get :description
    end
  end

  resources :proofs
  get '/proofs/:id/cancel_edit', to: 'proofs#cancel_edit', as: :cancel_edit
  get 'users/show'

  get 'static_pages/landing'
  get '/about', to: 'static_pages#about', as: :about
  get '/mathjax_cheatsheet', to: 'static_pages#mathjax_cheatsheet', as: :mathjax_cheatsheet
  get '/contact_us', to: 'static_pages#contact', as: :contact
  get '/tour', to: 'static_pages#tour', as: :tour
  get '/help', to: 'static_pages#help', as: :help

  devise_for :users, controllers: { registrations: "registrations", sessions: "sessions" }
  devise_scope :user do
    authenticated :user do
			root 'problems#feed'
		end
		
		unauthenticated do
			root 'static_pages#landing'
		end
  end
  resources :users, only: [:show, :index, :edit, :update] do
    member do
      get :problem_edits
      get :problems_following
      get :proofs
      get :activity
      get :followers
      get :following
      get :topic_edits
      get :topics_following
      post :follow
      delete :unfollow
      patch :update_image
    end
  end

  resources :reports, only: [:new, :create]

  resources :problems
  get "/feed", to: "problems#feed", as: :feed

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

  get '/main_search', to: 'users#main_search', as: :main_search
  mathjax 'mathjax'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
