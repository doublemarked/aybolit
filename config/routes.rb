Aybolit::Application.routes.draw do

  # Omniauth setup
  match "auth/:provider/callback" => "sessions#create"
  match "auth//vkontakte/client_callback" => "sessions#create_vkclient"
  match "auth//vkontakte/client_link" => "sessions#link_vkclient"
  match "auth/logout" => "sessions#destroy", :as => :logout
  match "auth/failure" => "sessions#failure"

  resources :hospitals, :only => [:index, :show] do
    get :locations, :on => :collection
  end

  match 'hospitals/autocomplete_locations' => 'hospitals#autocomplete_location_name', :as => "autocomplete_hospital_locations"
  match 'hospital/:id/autocomplete_doctors' => 'hospitals#autocomplete_doctor_name', :as => "autocomplete_hospital_doctors"

  resources :doctors, :only => [:index, :show] do
    get :autocomplete_doctor_name, :on => :collection, :as => :autocomplete
  end

  resources :reports, :except => :destroy do
    get :endorse, :on => :member
  end

  # Half-assed implementation of a few helpers for JS code
  scope '/jsonapi', :defaults => { :format => 'json' } do
    match 'getCurrentUser' => 'jsonapi#current_user'
  end

  get 'feedback' => 'feedback#new'
  post 'feedback' => 'feedback#create'
  
  match '*page' => 'pages#show', :constraints => { :page => /[\w-]+/ }, :as => "page"
  root :to => 'pages#show'
end
