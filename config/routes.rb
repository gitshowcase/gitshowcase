# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  devise_for :users, :controllers => {
      omniauth_callbacks: 'users/omniauth_callbacks',
      sessions: 'users/sessions'
  }

  authenticated :user do
    root :to => 'profile#show', as: :authenticated_root
    resources :projects, only: [:index, :new, :create, :edit, :update, :destroy]
    resources :languages, only: [:index, :update]
    resources :users, only: [:index, :update]
  end

  root to: 'landing#home'
  get '/:username', to: 'profile#show'
end
