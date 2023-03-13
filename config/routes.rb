Rails.application.routes.draw do
  root 'packages#index'

  resources :packages do
    get '/page/:page', action: :index, on: :collection
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
