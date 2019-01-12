Rails.application.routes.draw do

  resources :comments, only: [:new, :edit, :create, :update, :destroy]

  get '/comments/:id/cancel_edit_comment', to: 'comments#cancel_edit', as: :cancel_edit_comment
  get '/comments/cancel_new_comment', to: 'comments#cancel_new', as: :cancel_new_comment
  #get '/proofs/:id/cancel_new_comment', to: 'proofs#cancel_new', as: :cancel_new_comment


  resources :topics do
    member do
      get :problems
      get :proofs
      get :followers
      get :log
      get :description
    end
  end

  resources :proofs do
    member do
      get :log
      get :comments
    end
  end

  get '/proofs/:id/cancel_edit', to: 'proofs#cancel_edit', as: :cancel_edit
  get 'users/show'

  get 'static_pages/landing'
  get '/about', to: 'static_pages#about', as: :about
  get '/contact_us', to: 'static_pages#contact', as: :contact
  get '/tour', to: 'static_pages#tour', as: :tour

  get '/help', to: 'help_center#help', as: :help
  get '/help/priviliges/:id', to: 'help_center#priviliges', as: :priviliges
  get '/help/mathjax_cheatsheet', to: 'help_center#mathjax_cheatsheet', as: :mathjax_cheatsheet
  get '/help/topics', to: 'help_center#on_topics', as: :on_topics
  get '/help/good-problems', to: 'help_center#good_problems', as: :good_problems
  get '/help/problem-feed', to: 'help_center#on_problem_feed', as: :on_problem_feed
  get '/help/expected-behavior', to: 'help_center#expected_behavior', as: :expected_behavior
  get '/help/editing-posts', to: 'help_center#editing_posts', as: :editing_posts
  get '/help/creating-topics', to: 'help_center#creating_topics', as: :creating_topics
  get '/help/deleting-posts', to: 'help_center#deleting_posts', as: :deleting_posts
  get '/help/reputation', to: 'help_center#reputation', as: :reputation
  get '/help/badges', to: 'help_center#badges', as: :badges


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

  resources :reports, only: [:new, :create, :update, :index, :show] do
    collection do
      get 'reserved'
      get 'history'
      get 'users'
      get 'help'
    end

    member do
      get 'close'
      put 'close'
      put 'decline'
      put 'reserve'
      delete 'unreserve'
    end
  end

  resources :versions, only: [:show]
  resources :problems do
    member do
      get :followers
      get :comments
    end
  end
  get "/feed", to: "problems#feed", as: :feed

  get '/problems/:id/logs', to: 'problems#logs', as: :problem_logs
  resources :images, only: [:create, :destroy]
  put '/vote', to: 'users#vote', as: :vote

  post '/problems/:id/bookmark', to: 'problems#bookmark', as: :problem_bookmark
	delete '/problems/:id/unbookmark', to: 'problems#unbookmark', as: :problem_unbookmark

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
