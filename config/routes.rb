Rails.application.routes.draw do
  resource :auth, only: %i[show create destroy], controller: :auth
  resource :auth_verifications, only: %i[show create]

  get 'pages/homepage'
  root to: "pages#homepage"
end
