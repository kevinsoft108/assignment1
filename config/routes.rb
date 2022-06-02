Rails.application.routes.draw do
  get 'pages/homepage'
  root "pages#homepage"
end
