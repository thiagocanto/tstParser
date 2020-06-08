Rails.application.routes.draw do
  post "/" => "integration_processes#parse"
end
