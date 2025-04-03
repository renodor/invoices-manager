# frozen_string_literal:true

Rails.application.routes.draw do
  root to: "invoices#index"

  devise_for :users
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

  resources :quotes, only: %i[index new create show destroy] do
    resources :line_items
    resources :description_blocks do
      member do
        patch :update_position
      end
    end
    member do
      get :edit_client
      patch :update_client
      get :edit_infos
      patch :update_infos
      get :edit_with_agreement
      patch :update_with_agreement
      get :export_to_pdf
    end
  end

  get "/sign_in_demo_user", to: "pages#sign_in_demo_user"
end
