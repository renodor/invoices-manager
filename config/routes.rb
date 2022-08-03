# frozen_string_literal:true

Rails.application.routes.draw do
  root to: 'invoices#index'

  devise_for :users
  resources :clients, only: %i[edit update index]
  resources :invoices do
    resources :line_items
    resources :days do
      collection do
        post :generate_month
        post :remove_month
      end
    end
    member do
      get :edit_client
      patch :update_client
      get :edit_infos
      patch :update_infos
      get :edit_bank
      patch :update_bank
      get :export_to_pdf
    end
  end
end
