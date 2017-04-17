# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  # Error pages
  match '/404', to: 'pages#not_found', via: :all, as: :not_found
  match '/500', to: 'pages#internal_server_error', via: :all, as: :internal_server_error

  # GitShowcase.com
  constraints domain: ENV['APP_DOMAIN'] || 'localhost' do
    # Pages
    get '/license', to: 'pages#license'
    get '/privacy_policy', to: 'pages#privacy_policy'
    get '/sitemap-users.xml', to: 'pages#sitemap_users'

    # SSL Route
    get '/.well-known/acme-challenge/:id', to: 'pages#letsencrypt'

    # Authentication
    devise_for :users, controllers: {
        omniauth_callbacks: 'users/omniauth_callbacks',
        sessions: 'users/sessions'
    } do
      get 'users/sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
    end

    # Dashboard
    authenticated :user do
      namespace :dashboard do
        controller :users do
          get '/', action: :home, as: :home

          get 'domain'
          match 'domain', action: :update_domain, as: :update_domain, via: [:put, :patch]

          get 'profile'
          match 'profile', action: :update_profile, as: :update_profile, via: [:put, :patch]

          get 'socials'
          match 'socials', action: :update_socials, as: :update_socials, via: [:put, :patch]

          get 'skills'
          match 'skills', action: :update_skills, as: :update_skills, via: [:put, :patch]

          get 'experience'
          match 'experience', action: :update_experience, as: :update_experience, via: [:put, :patch]

          get 'education'
          match 'education', action: :update_education, as: :update_education, via: [:put, :patch]

          get 'settings'

          get 'sync_profile'
        end

        resource :users, only: [:destroy]

        controller :projects do
          get 'sync_projects'
        end

        resources :projects, only: [:index, :new, :create, :edit, :update, :destroy] do
          collection do
            get ':id/sync', action: :sync, as: :sync
            get ':id/show', action: :show, as: :show
            get ':id/hide', action: :hide, as: :hide
            post 'order'
          end
        end
      end

      scope path: '/setup' do
        controller :setup do
          get '/', action: :cover, as: :setup
          get 'socials', as: :setup_socials
          get 'skills', as: :setup_skills
          get 'theme', as: :setup_theme
        end
      end

      root to: redirect('/dashboard')
    end

    root to: 'landing#home'
  end

  # Admin
  namespace :admin do
    controller :analytics do
      get '/', action: :home, as: :home
    end

    resources :users, only: [:index]
    resources :setup_covers, only: [:index, :create, :destroy]

    namespace :monitor do
      # Sidekiq
      require 'sidekiq/web'
      mount Sidekiq::Web => 'queue', as: :queue
    end
  end

  # Profile
  controller :profile do
    get ':username', action: :home, as: :profile
  end

  root 'profile#home'
end
