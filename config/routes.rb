Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post '/api/command', to: 'slack_commands#update'
  post '/api/events', to: 'slack_events#post'
  post '/api/messages', to: 'slack_messages#message'
  post '/api/messages/options', to: 'slack_messages#options'
end
