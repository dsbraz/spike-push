require 'rubygems'
require 'em-websocket'
require 'sinatra/base'
require 'thin'
require 'redis'
require 'json'
require 'pry'

# SOCKETS = []

# Thread.new do
#   redis = Redis.new
#   redis.subscribe('cliente_1') do |on|
#     on.message do |channel, message|
#       SOCKETS.each do |s|
#         s.send message
#       end
#    end
#   end
# end

EventMachine.run do
  class App < Sinatra::Base
      set :bind, '4567'

      get '/' do
          erb :index
      end
  end

  EventMachine::WebSocket.start(:host => '0.0.0.0', :port => 8080) do |ws|
    # ws.onopen {
    #   SOCKETS << ws
    # }

    ws.onmessage { |message|
      obj = JSON.parse message
      case obj['action']
      when 'subscribe'
        Thread.new do
          redis = Redis.new
          redis.subscribe(obj['channel']) do |on|
            on.message do |channel, message|
              ws.send message
           end
          end
        end
      when 'publish'
        redis = Redis.new
        redis.publish obj['channel'], obj['message']
      end
    }

    # ws.onclose {
    #   SOCKETS.delete ws
    # }
  end

  App.run!
end
