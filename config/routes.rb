Rails.application.routes.draw do
  devise_for :users, skip: [:registrations]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'base#index'
  resources :users do
    post 'undelete'
  end
end
