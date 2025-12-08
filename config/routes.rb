Rails.application.routes.draw do
  devise_for :users

  devise_scope :user do
    get "users/sign_out", to: "devise/sessions#destroy"
  end

  get "up" => "rails/health#show", as: :rails_health_check

  root "homes#index"
  get "homes/index"

  resources :posts, only: %i[index new create show] do
    resources :stories, only: [:create]
    resources :period_stories, only: [:show]
  end

  resources :period_stories, only: [:index, :show] do
    collection do
      post :generate_weekly
    end

    member do
      post :save_to_list
    end
  end
end
