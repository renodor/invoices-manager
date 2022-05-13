# frozen_string_literal:true

Rails.application.routes.draw do
  root to: 'pages#home'

  devise_for :users
  resources :clients, only: %i[edit update index]
  resources :invoices do
    resources :line_items
    resources :days do
      collection do
        get :generate_month
      end
    end
    member do
      get :edit_client
      patch :update_client
      get :edit_infos
      patch :update_infos
    end
  end
end
