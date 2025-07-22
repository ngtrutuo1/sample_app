Rails.application.routes.draw do

  scope "(:locale)", locale: /en|vi/ do
    root "static_page#home"
    
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

    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    
    resources :users, only: :show
  end
end
