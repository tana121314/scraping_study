Rails.application.routes.draw do
  get '/' => 'products#index'
  resources :products, only: :index do
    collection do
      post :search
    end
  end
end
