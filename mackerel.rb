#!/usr/bin/env ruby

require "optparse"
require_relative "lib/server"

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: mackerel.rb [options] directory"

  opts.on("-pPORT", "--port=PORT", "Specify the port (default: #{Server::DEFAULTS[:port]})") do |p|
    options[:port] = p
  end

  opts.on("-s", "--single-threaded", "Run the server in single-threaded mode") do |p|
    options[:threading] = false
  end

  opts.on_tail("-h", "--help", "Prints this help") do
    puts opts
    exit
  end
end.parse!
options[:directory] = ARGV.first if ARGV.any?

Server.new(options).run
