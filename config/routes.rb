Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    # Root path
    root "static_page#home"

    # Account activation
    get 'account_activations/edit'

    # Signup
    get  "/signup", to: "users#new"
    get ":id/settings", to: "users#edit", as: :settings

    # Login/Logout
    get    "/login",  to: "sessions#new"
    post   "/login",  to: "sessions#create"
    delete "/logout", to: "sessions#destroy"

    resources :users
    resources :account_activations, only: :edit
    resources :password_resets, only: %i[new create edit update]
    resources :microposts, only: %i(create destroy)
    resources :users do
      member do
        get :following, :followers
      end
    end

    resources :relationships, only: %i(create destroy)

    # Static pages
    resources :static_page, only: [] do
      get "home", on: :collection
      get "help", on: :collection
    end

    # Contact pages
    resources :contact_page, only: [] do
      get "home", on: :collection
    end
  end
end
