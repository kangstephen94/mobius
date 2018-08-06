Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: redirect('/users')
  
  namespace :api, defaults: {format: :json} do
    get '/v1/users/current', :to => 'data#current_user_info'
  end

  resource :session, only: [:new, :create, :destroy]

  resources :users, only: [:index, :new, :create] do
    get :activate, on: :collection
    member do
      patch :send_credits
    end
  end
end