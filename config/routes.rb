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

    # Authentication
    devise_for :users, controllers: {
        omniauth_callbacks: 'users/omniauth_callbacks',
        sessions: 'users/sessions'
    } do
      get 'users/sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
    end

    # Admin
    authenticated :user, lambda { |u| u.admin } do
      namespace :admin do
        controller :analytics do
          get '/', action: :home, as: :home
        end

        resources :users, only: [:index, :show]
        resources :invitations, only: [:index]
        resources :plans, only: [:index, :show]
        resources :setup_covers, only: [:index, :create, :destroy]

        namespace :monitor do
          # Sidekiq
          require 'sidekiq/web'
          mount Sidekiq::Web => 'queue', as: :queue
        end
      end

      root to: redirect('/admin')
    end

    # Dashboard
    authenticated :user do
      namespace :dashboard do
        controller :users do
          get '/', action: :home, as: :home

          get 'domain'
          match 'domain', action: :update_domain, via: [:put, :patch]

          get 'profile'
          match 'profile', action: :update_profile, via: [:put, :patch]

          get 'socials'
          match 'socials', action: :update_socials, via: [:put, :patch]

          get 'skills'
          match 'skills', action: :update_skills, via: [:put, :patch]

          get 'experience'
          match 'experience', action: :update_experience, via: [:put, :patch]

          get 'education'
          match 'education', action: :update_education, via: [:put, :patch]

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

      scope path: '/setup', as: :setup do
        controller :setup do
          get '/', action: :profile, as: :profile
          match '/', action: :update_profile, via: [:put, :patch]

          get 'cover', action: :cover
          match 'cover', action: :update_cover, via: [:put, :patch]

          get 'socials'
          match 'socials', action: :update_socials, via: [:put, :patch]

          get 'skills'
          match 'skills', action: :update_skills, via: [:put, :patch]

          get 'projects'

          get 'theme'
          match 'theme', action: :update_theme, as: :update_theme, via: [:put, :patch]
        end
      end

      root to: redirect('/dashboard')
    end

    controller :landing do
      get 'invitation/:username', as: :invitation, action: :invitation
    end

    root to: 'landing#home'
  end

  # Profile
  controller :profile do
    get ':username', action: :home, as: :profile
  end

  root 'profile#home'
end
