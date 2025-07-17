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
  end

end
