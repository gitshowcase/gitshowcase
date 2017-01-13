# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  resources :skills
  resources :projects, template: 'dashboard'

  devise_for :users, :controllers => {
      omniauth_callbacks: 'users/omniauth_callbacks',
      sessions: 'users/sessions'
  }

  authenticated :user do
    root :to => 'profile#show', as: :authenticated_root
  end

  root to: 'landing#home'
  get '/:username', to: 'landing#home'
end
