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
    puts options.inspect
  end
end
