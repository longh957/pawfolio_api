Rails.application.routes.draw do
  root to: redirect('http://www.longkhuynh.com')

  namespace :api do
    namespace :v1 do
      resource :authentication, only: %i[create]
      resource :registration, only: %i[create update destroy]
    end
  end
end
