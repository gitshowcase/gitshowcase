# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  resources :skills

  authenticated :user do
    root :to => 'profile#show', as: :authenticated_root
  end

  root to: 'landing#home'

  resources :projects, template: 'dashboard'

  devise_for :users, :controllers => {
      omniauth_callbacks: 'users/omniauth_callbacks',
      sessions: 'users/sessions'
  }
end
