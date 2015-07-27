require "./http_error"
require "./response"

class Request < Struct.new(:headers, :uri, :body)
  REQUEST_FORMAT = /^(\w+)\s+([^\s]+)\s+HTTP\/(\d+(?:\.(\d+)))$/

  def send_response
    Response.new.write_to socket
  end

  def self.parse(server, socket)
    bad_request! unless request_line = socket.gets

    request_line.chomp!

    if request_line =~ REQUEST_FORMAT && $3.to_i == 1
      verb = $1
      uri = $2

      server.log_request request_line

      klass = request_class_for verb
      if klass
        headers = []
        while line = socket.gets
          break if line.strip.empty?
          headers << line
        end
        # body = socket.readlines
        body = []

        klass.new headers, uri, body
      else
        bad_request!
      end
    else
      bad_request!
    end
  end

  def self.bad_request!
    raise HTTPError, 400
  end

  private

  def self.verb
    name.split("::").last.upcase
  end

  def self.valid_request_types
    @request_types ||= Dir.glob(File.dirname(__FILE__) + "/request/*.rb").map do |file|
      require file
      self.const_get File.basename(file, ".rb").sub(/^./) { |letter| letter.upcase }
    end
  end

  def self.request_class_for(verb)
    verb.upcase!
    valid_request_types.detect { |type| type.verb == verb }
  end
end
