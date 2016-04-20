require 'socket' 
require_relative 'messenger/messenger.rb'

class Server
  
  def startup  
    
    @messenger = Messenger.new
    @server = TCPServer.new 80
    
    loop do

      socket = @server.accept
      test = "test"
      STDERR.puts test
      request = socket.recv(4096)
      STDERR.puts request
      #ie: Dave|sendMessage|Catherine|i am working on marvin|
      #ie: Dave|requestAmount|
      #ie: Dave|readMessage|4
 
      handle_request(request)
      response = build_response(request)

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
    request_type = args[1]
    case request_type
    when 'sendMessage'
      print args[2] + " " +args[1] + " "+ args[3]
      @messenger.send_message(args[2], args[0], args[3])
    when 'requestAmount'
    when 'getMessage'
    end
  end

  def build_response(request)
    response = "Hi"
  end
end

s = Server.new
s.startup
