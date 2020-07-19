Rails.application.routes.draw do
  get '/' => 'products#index'
  resources :products, only: :index do
    collection do
      post :mercari
    end
  end
end
