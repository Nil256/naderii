Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'homes#top'

  get "/users/@:username/edit/dangerzone" => "users#dangeredit", as: "dangeredit_user"
  get "/users/@:username/edit" => "users#edit", as: "edit_user"
  get "/users/@:username" => "users#show", as: "user"
  patch "/users/@:username/danger" => "users#dangerupdate", as: "dangerupdate_user"
  put "/users/@:username/danger" => "users#dangerupdate"
  patch "/users/@:username" => "users#update", as: "update_user"
  put "/users/@:username" => "users#update"
end
