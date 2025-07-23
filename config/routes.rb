Rails.application.routes.draw do

  scope "(:locale)", locale: /en|vi/ do
    root "static_page#home"

    controller :users do
      get  "/signup",   to: "users#new",    as: :signup
      post "/signup" ,  to: "users#create"
    end

    controller :sessions do
      get    "/login",  to: "sessions#new",     as: :login
      post   "/login",  to: "sessions#create"
      delete "/logout", to: "sessions#destroy", as: :logout
    end

    resources :static_page do   
      get "home", on: :collection
      get "help", on: :collection
    end

    resources :contact_page do  
      get "home", on: :collection
    end

    resources :micropost_page do  
      get "home", on: :collection
    end
    
    resources :users, only: :show
  end
end
