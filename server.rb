require "socket"
require "./client"

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
      begin
        socket = server.accept_nonblock
      rescue IO::WaitReadable, Errno::EINTR
        IO.select([server])
        retry
      end

      Client.new(socket).handle_request
    end
  end

  def server
    @server ||= TCPServer.new port
  end

  def port
    options[:port]
  end
end
