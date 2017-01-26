# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  devise_for :users, :controllers => {
      omniauth_callbacks: 'users/omniauth_callbacks',
      sessions: 'users/sessions'
  } do
    get 'users/sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  authenticated :user do
    root :to => 'dashboard#home', as: :authenticated_root

    resources :projects, only: [:index, :new, :create, :edit, :update, :destroy] do
      collection do
        get ':id/sync', as: :sync, action: :sync
        get ':id/show', as: :show, action: :show
        get ':id/hide', as: :hide, action: :hide
        post 'order'
      end
    end

    resources :users, only: [:index, :update] do
      collection do
        get 'sync'
        get 'sync_projects'
        get 'socials'
        get 'skills'
        get 'setup'
      end
    end

    controller 'setup' do
      get 'sync'
    end
  end

  root to: 'landing#home'

  controller 'profile' do
    get '/:username', action: 'show'
  end
end
