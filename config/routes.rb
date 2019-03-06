Rails.application.routes.draw do
  devise_for :users, skip: [:registrations]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'base#index'
  resources :users do
    post 'undelete'
    get 'user_profile'
  end

  # REST APIs
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      post :request_otp, to: 'authentication#request_otp'
      post :verify_otp, to: 'authentication#verify_otp'
      post :resend_otp, to: 'authentication#resend_otp'
    end
  end
end
