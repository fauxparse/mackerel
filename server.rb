require "socket"

class Server
  DEFAULTS = {
    port: 80,
    directory: "."
  }

  attr_accessor :options

  def initialize(options)
    @options = DEFAULTS.merge options
  end

  def run
    loop do
      client = server.accept    # Wait for a client to connect
      client.puts "Hello !"
      client.puts "Time is #{Time.now}"
      client.close
    end
  end

  def server
    @server ||= TCPServer.new port
  end

  def port
    options[:port]
  end
end
