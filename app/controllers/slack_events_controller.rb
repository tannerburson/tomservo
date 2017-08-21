class SlackEventsController < ApplicationController
  def post
    router = Servo::Router.build do |r|
      r.route text: [/tomservo/i,/is a bot/] do |opts,event|
        puts "I'm probably not a bot. Am i?"
        client = Slack::Web::Client.new
        client.chat_postMessage(channel: event['event']['channel'], text: "Hey <@#{event['event']['user']}>, I really don't think I'm a bot. Am I? Oh man...existential crisis")
      end

      r.route text: /tomservo/i do |opts,event|
        puts "Heard my name, and #{event}"
      end

      r.matching do |route,payload|
        text_matches = [false]
        text_matches = *route[:text] if route[:text]
        text_matches.all? {|t| t =~ payload['event']['text'] }
      end
    end

    begin
      msg = params.to_unsafe_h
      router.route!(msg)
    rescue => e
      puts e.inspect
    end


    render plain: params[:challenge] and return if 'url_verification' == params[:type]
  end
end
