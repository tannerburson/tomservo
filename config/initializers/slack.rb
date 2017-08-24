require 'servo/slack'
require "#{Rails.root}/app/controllers/slack/channel_page_message"
require "#{Rails.root}/app/controllers/slack/page_an_engineer_command"

SLACK_NOTIFICATION_CHANNEL = '#botplayground'

Slack.configure do |config|
  config.token = ENV['SLACK_API_TOKEN']
end

MessageRouter = Servo::Slack::Router.build(client: Slack::Web::Client.new) do |r|
  r.route({callback_id: 'page_severity'}, to: ChannelPageMessage)

  r.matching do |route,payload|
    route[:callback_id] == payload['callback_id']
  end
end

CommandRouter = Servo::Slack::Router.build do |r|
  r.route '/i-need-an-engineer', to: PageAnEngineerCommand

  r.matching do |route,payload|
    route == payload[:command]
  end
end


