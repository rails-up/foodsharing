Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations',
                                    omniauth_callbacks: 'omniauth_callbacks' }

  get 'welcome/index'
  root 'welcome#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :articles

  resources :donations
  resources :companies, except: [:index, :show]

  #Admin
  namespace :admin do
    get "/", to: "admin#dashboard", as: "dashboard"
  end
end
