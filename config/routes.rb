# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  devise_for :users, :controllers => {
      omniauth_callbacks: 'users/omniauth_callbacks',
      sessions: 'users/sessions'
  } do
    delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end
end
