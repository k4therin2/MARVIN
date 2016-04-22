require 'socket'
require 'mqtt'
require 'rubygems' 
require_relative 'messenger/messenger.rb'

class Server
  
  def startup  
    
    @messenger = Messenger.new
    @server = TCPServer.new 77
    
    loop do

      socket = @server.accept
      test = "test"
      STDERR.puts test
      request = socket.recv(4096)
      STDERR.puts request
      #  
      # Dave|sendMessage|Catherine|i am working on marvin|
      #ie
      # checkMessages: "check messages"
      #    token|checkMessages| 
      #    response: You have messages from Dave, Bob and Cindy. 
      # readMessage: 
      #    token|readMessage|bob
      #    response: Bob says "Hello."

 
      response =  handle_request(request)

      response_header = "HTTP/1.1 200 OK\r\n" +
               "Content-Type: text/plain\r\n" +
               "Content-Length: #{response.bytesize}\r\n" +
               "Connection: close\r\n" + "\r\n"

      response_full = response
      socket.print response_full
      socket.close
    end

  end

  def handle_request(request)
    args = request.split('|')
    token = args[0]
    request_type = args[1]
    response = "There was an issue with your request."
    case request_type
    when 'sendMessage'
      print args[2] + " " +args[1] + " "+ args[3]
      @messenger.send_message(args[2], args[0], args[3])
      MQTT::Client.connect('localhost') do |c|
        c.publish(args[2], 'notify')
      end
      response = "Message sent!"
    when 'checkMessages'
      response = @messenger.build_check_messages_response(token)
    when 'readMessages'
        response = @messenger.build_read_messages_response(token)      
    when 'readMessage'
        response = @messenger.build_read_message_response(token, args[2])
    end
  end
end

s = Server.new
s.startup
