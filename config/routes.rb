Rails.application.routes.draw do
  root "static#home"
  scope module: :api, defaults: { format: :json } do
    post "auth/login", to: "authentication#login"
    get "auth/logout", to: "authentication#logout"
    post "signup", to: "users#create"
    scope module: :v1, constraints: ApiConstraint.new(version: 1) do
      with_options except: [:new, :edit] do |route|
        route.resources :buckets, path: "/bucketlists" do
          route.resources :items
        end
      end
    end
  end
  match "*all",
    to: "application#not_found",
    defaults: { format: :json },
    via: :all
end
