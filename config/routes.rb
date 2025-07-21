Rails.application.routes.draw do

  scope "(:locale)", locale: /en|vi/ do
    root "static_page#home"

    controller :users do
      get  '/signup', action: :new
      post '/signup', action: :create
    end

    controller :sessions do
      get    '/login',  action: :new
      post   '/login',  action: :create
      delete '/logout', action: :destroy
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
