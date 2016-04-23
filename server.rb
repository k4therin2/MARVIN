require 'socket'
require 'mqtt'
require 'rubygems'
require_relative 'messenger/messenger.rb'

class Server
  def startup
    @messenger = Messenger.new
    @server = TCPServer.new 77

    loop do
      # open socket
      socket = @server.accept
      # receive data from alexa
      request = socket.recv(4096)
      # generate an appropriate response
      response = handle_request(request)
      # send the response
      socket.print response
      # close up shop
      socket.close
    end
  end

  # parses response from alexa and calls appropriate functions
  def handle_request(request)
    args = request.split('|')
    token = args[0]
    request_type = args[1]
    response = 'There was an issue with your request.'

    case request_type
    when 'sendMessage'
      print args[2] + ' ' + args[1] + ' ' + args[3]
      response = @messenger.send_message(args[2], args[0], args[3])
      MQTT::Client.connect('localhost') do |c|
        c.publish(args[2].downcase, 'notify')
      end
      response
    when 'checkMessages'
      response = @messenger.build_check_messages_response(token)
    when 'readMessages' # read all messages
      response = @messenger.build_read_messages_response(token)
    when 'readMessage' # read one message from a specified sender
      response = @messenger.build_read_message_response(token, args[2])
    when 'checkMood'
      response = @messenger.build_check_mood_response(token, args[2])
    end
  end
end

s = Server.new
s.startup

