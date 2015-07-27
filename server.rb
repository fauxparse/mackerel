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

      Client.new(self, socket).handle_request
    end
  end

  def server
    @server ||= TCPServer.new port
  end

  def port
    options[:port]
  end

  def root
    File.expand_path options[:directory], File.dirname(__FILE__)
  end

  def log_request(request_line)
    puts request_line
  end
end
