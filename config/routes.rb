Zalupaka::Application.routes.draw do
  # You can have the root of your site routed with "root"
  root 'dashboard#index'

  get 'voice/voice'
  get 'voice/generate'
  post 'voice/recognize'

end
