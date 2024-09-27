Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }

  


  # Add the routes for projects
  resources :projects
  resources :users


  # Add custom routes for setting/removing admin role for users
  resources :users do
    member do
      patch :set_admin    # Route for setting a user as admin
      patch :remove_admin # Route for removing a user's admin status
    end
  end

  get "home/about"
  root "projects#index"

  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
