Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'password_resets/create'
  get 'password_resets/update'
  scope "(:locale)", locale: /en|vi/ do
    # Root path
    root "static_page#home"

    # Account activation
    get 'account_activations/edit'

    # Signup alias
    get  "/signup", to: "users#new"
    get ":id/settings", to: "users#edit", as: :settings

    # Login/Logout
    get    "/login",  to: "sessions#new"
    post   "/login",  to: "sessions#create"
    delete "/logout", to: "sessions#destroy"

    resources :users
    resources :account_activations, only: :edit
    resources :password_resets, only: %i(new create edit update)

    # Static pages
    resources :static_page, only: [] do
      get "home", on: :collection
      get "help", on: :collection
    end

    resources :contact_page, only: [] do
      get "home", on: :collection
    end

    resources :micropost_page, only: [] do
      get "home", on: :collection
    end
  end
end
