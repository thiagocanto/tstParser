Rails.application.routes.draw do
  post "/" => "orders#parse"
end
