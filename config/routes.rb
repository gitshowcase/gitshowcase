# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  devise_for :users, :controllers => {
      omniauth_callbacks: 'users/omniauth_callbacks',
      sessions: 'users/sessions'
  } do
    get 'users/sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  authenticated :user do
    root :to => 'profile#show', as: :authenticated_root

    resources :projects, only: [:index, :new, :create, :edit, :update, :destroy] do
      collection do
        get ':id/sync', as: :sync, action: :sync
      end
    end

    resources :skills, only: [:index, :update]

    resources :users, only: [:index, :update] do
      collection do
        get 'sync'
        get 'sync_projects'
      end
    end
  end

  root to: 'landing#home'
  get '/:username', to: 'profile#show'
end
