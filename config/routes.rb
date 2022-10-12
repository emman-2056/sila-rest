Rails.application.routes.draw do
  # devise_for :users
  # devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  devise_for :users,
  controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations'
  },
  defaults: {
    format: :json
  }











  # namespace :api do
  #   namespace :v1 do
  #     # resources :users
  #     # resources :facts
  #     get "/users", to: "users#index"
  #     get "/users/checkNewUsers", to: "users#checkNewUsers"
  #     post "/users/create-new-user", to: "users#createNewUser"
  #   end
  # end

  namespace :api do
    namespace :v1 do
      get "/users", to: "users#index"
      get "/share", to: "shares#index"

      get "/users/get-result", to: "users#getResult"


      get "/video-editor", to: "video_editor#index"
      # get "/video-editor-get-render", to: "video_editor#getRender"
      get '/video-editor-get-render/:id', to: 'video_editor#getRender'
      # get '/patients/:id', to: 'patients#show'



      # AWS Cognito routes
      get "/cognito", to: "cognito#index"
      post "/cognito/create-user", to: "cognito#create_user"
      post "/cognito/confirm-signup", to: "cognito#confirm_signup"
      post "/cognito/sign-in", to: "cognito#sign_in"
      get "/cognito/get-user", to: "cognito#get_user"
      get "/cognito/sign-out", to: "cognito#sign_out"

      # Rollbar routes
      get "/rollbar", to: "rollbar#index"
    end
  end
  

end
