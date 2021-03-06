Dorsale::Engine.routes.draw do
  resources :comments, only: [:create, :edit, :update, :destroy]

  namespace :small_data do
    resources :filters, only: [:create]
  end

  namespace :alexandrie do
    resources :attachments, only: [:create, :destroy]
  end

  namespace :flyboy do
    resources :folders do
      member do
        patch :open
        patch :close
      end
    end

    resources :tasks do
      member do
        patch :complete
        patch :snooze
      end
    end

    resources :task_comments, only: [:create]
  end

  namespace :billing_machine do
    resources :invoices, except: [:destroy] do
      member do
        get :copy
        patch :pay
      end
    end

    resources :quotations
  end

  namespace :customer_vault do
    resources :corporations, except: [:index] do
      resources :links, except: [:index]
    end

    resources :individuals, :except => [:index] do
      resources :links, except: [:index]
    end

    namespace :people do
      get "/", action: "index"
      get :activity
      get :list
    end
  end
end
