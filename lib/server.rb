require "socket"
require_relative "./client"

class Server
  DEFAULTS = {
    port: 80,
    directory: ".",
    threading: true
  }

  attr_accessor :options

  def initialize(options)
    @options = DEFAULTS.merge options
  end

  def run
    loop do
      if options[:threading]
        Thread.fork(server.accept) do |socket|
          handle_request socket
        end
      else
        handle_request server.accept
      end
    end
  end

  def server
    @server ||= TCPServer.new port
  end

  def port
    options[:port]
  end

  def root
    File.expand_path options[:directory], File.dirname(File.dirname(__FILE__))
  end

  def log_request(request_line)
    puts request_line
  end

  def handle_request(socket)
    Client.new(self, socket).handle_request
  end
end
