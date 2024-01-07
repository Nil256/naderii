Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "homes#top"

  get "/home" => "homes#main", as: "home"

  get "/users/@:username/edit/dangerzone" => "users#dangeredit", as: "dangeredit_user"
  get "/users/@:username/edit" => "users#edit", as: "edit_user"
  get "/users/@:username" => "users#show", as: "user"
  patch "/users/@:username/danger" => "users#dangerupdate", as: "dangerupdate_user"
  put "/users/@:username/danger" => "users#dangerupdate"
  patch "/users/@:username" => "users#update", as: "update_user"
  put "/users/@:username" => "users#update"

  # get 'timelines/search'
  get "/timelines/@:timelinename/edit" => "timelines#edit", as: "edit_timeline"
  get "/timelines/@:timelinename" => "timelines#show", as: "timeline"
  patch "/timelines/@:timelinename" => "timelines#update", as: "update_timeline"
  put "/timelines/@:timelinename" => "timelines#update"
  resources :timelines, only: [:index, :new, :create]
end
