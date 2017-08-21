module Servo
  class RouteNotMatchedError < StandardError; end;
  class Router
    def initialize(opts={},&blk)
      @raw_payload = opts.delete(:payload) { nil }
      @config = opts.delete(:config) { RouterConfiguration.new(opts,&blk) }
    end

    def self.build(opts={},&blk)
      new(opts,&blk)
    end

    def config
      @config
    end

    def routes
      config.routes
    end

    def match_block
      config.match_block
    end

    def route!(data,&blk)
      payload = parse_payload(data)
      route,route_blk = routes.find do |k,v|
        match_block.call(k,payload)
      end
      raise RouteNotMatchedError.new("No route matches: #{payload.inspect}") if !route_blk
      route_blk.call(route_options(route),payload)
    end

    private
    def route_options(route)
      { name: route, client: config.client, options: config.options }
    end

    def parse_payload(data)
      case data
        when String
          JSON.parse(data)
        else
          data.to_h
        end
    end
  end

  class RouterConfiguration
    def initialize(opts={})
      @routes = opts.delete(:routes){ Hash.new }
      @client = opts.delete(:client){ Slack::Web::Client.new}
      @opts = opts
      yield self if block_given? #initializer configuration
    end

    def options
      @opts
    end

    def routes
      @routes
    end

    def client
      @client
    end

    def match_block
      @match_block
    end

    def add_route(key,to: nil,&blk)
      if !to && !blk
        routes[key]
      else
        blk = Proc.new {|opts,data| to.call(opts,data) } if to
        routes[key] = blk
      end
    end
    alias_method :route, :add_route
    alias_method :on, :add_route

    def matching(&blk)
      @match_block = blk if blk
    end
  end
end
