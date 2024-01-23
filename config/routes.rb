Rails.application.routes.draw do
  # get 'user_follows/create'
  # get 'user_follows/destroy'
  # get 'timeline_follows/create'
  # get 'timeline_follows/destroy'
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "homes#top"

  get "/home" => "homes#main", as: "home"
  get "/search" => "searches#search", as: "search"

  resources :notifications, only: [:index]
  post "/timelinetransfer/:id" => "notifications#timelinetransferaccept", as: "response_timeline_transfer"
  delete "/timelinetransfer/:id" => "notifications#timelinetransferreject"
  delete "/notifications" => "notifications#destroy"

  post "/users/@:username/follows" => "user_follows#create", as: "user_follows"
  delete "/users/@:username/follows" => "user_follows#destroy"

  get "/users/@:username/edit/dangerzone" => "users#dangeredit", as: "dangeredit_user"
  get "/users/@:username/edit" => "users#edit", as: "edit_user"
  get "/users/@:username" => "users#show", as: "user"
  patch "/users/@:username/danger" => "users#dangerupdate", as: "dangerupdate_user"
  put "/users/@:username/danger" => "users#dangerupdate"
  patch "/users/@:username" => "users#update", as: "update_user"
  put "/users/@:username" => "users#update"
  get "/users/following" => "users#following", as: "following_users"

  post "/cries" => "cries#privatecreate", as: "private_cries"
  post "/timelines/@:timelinename/cries" => "cries#publiccreate", as: "public_cries"
  resources :cries, only: [:show, :destroy] do
    resource :pets, only: [:create, :destroy]
  end

  post "/timelines/@:timelinename/follows" => "timeline_follows#create", as: "timeline_follows"
  delete "/timelines/@:timelinename/follows" => "timeline_follows#destroy"

  post "/timelines/@:timelinename/transfer" => "timelines#transferrequest", as: "timeline_transfer"
  delete "/timelines/@:timelinename/transfer" => "timelines#transfercancel"
  get "/timelines/@:timelinename/edit/dangerzone" => "timelines#dangeredit", as: "dangeredit_timeline"
  get "/timelines/@:timelinename/edit" => "timelines#edit", as: "edit_timeline"
  get "/timelines/@:timelinename" => "timelines#show", as: "timeline"
  delete "/timelines/@:timelinename" => "timelines#destroy", as: "destroy_timeline"
  patch "/timelines/@:timelinename/danger" => "timelines#dangerupdate", as: "dangerupdate_timeline"
  put "/timelines/@:timelinename/danger" => "timelines#dangerupdate"
  patch "/timelines/@:timelinename" => "timelines#update", as: "update_timeline"
  put "/timelines/@:timelinename" => "timelines#update"
  get "/timelines/followed" => "timelines#followed", as: "followed_timelines"
  get "/timelines/managed" => "timelines#managed", as: "managed_timelines"
  resources :timelines, only: [:index, :new, :create]

  get "/iwanttobekindothers" => "homes#adminimain", as: "adm"
end
