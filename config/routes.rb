Rails.application.routes.draw do

  # Redirect www to no-www
  constraints subdomain: 'www' do
    get ':any', to: redirect(subdomain: nil, path: '/%{any}'), any: /.*/
  end

  root 'home#index'

  # Collections
  get 'made-in-:country', to: 'collections#made_in'
  get 'produced-in-:country', to: 'collections#made_in'

  resources :products, only: [:show], param: :slug
  resources :currencies, only: [:update], param: :code

  namespace :dashboard do
    root 'brands#index'
    resources :brands
    resources :products, param: :slug
    resources :newsletters, only: [:index]
  end

  namespace :api, constraints: { format: 'json' } do
    resources :products, only: [:index]
    resources :newsletters, only: [:create]
  end

end

