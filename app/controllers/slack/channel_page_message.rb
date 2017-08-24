class ChannelPageMessage
  attr_reader :client
  attr_reader :payload

  def initialize(opts)
    @client = opts.fetch(:client)
    @name = opts.fetch(:name)
    @payload = nil
  end

  def self.call(opts,msg)
    new(opts).call(msg)
  end

  def call(msg)
    @payload = msg
    client.chat_postMessage(channel: ENV['PAGE_NOTIFICATION_CHANNEL'], text: "#{sent_from}: #{selected_option['value']} \"#{selected_option['text']}\" #{alert_level_for(selected_option['value'])}")
    return 'Got it! :+1: Message has been relayed, someone will get back with you.'
  end

  def sent_from
    "<@#{payload['user']['id']}|#{payload['user']['name']}>"
  end

  def selected_option
    val = payload['actions'].first['selected_options'].first['value']
    @option ||= JSON.parse(val) if val
  end

  def alert_level_for(value)
    case(value)
      when 'outage'
        '<!channel>'
      when 'mostly_busted'
        '<!here>'
      else
        ''
    end
  end
end

