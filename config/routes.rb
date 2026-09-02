Ffe::Engine.routes.draw do
  resources :feature_flags do
    get :dump, on: :collection
  end
end
