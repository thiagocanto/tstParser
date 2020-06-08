Rails.application.routes.draw do
  root to: "orders#index"
  post "/" => "orders#create"
end
