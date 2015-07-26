class Response
  MESSAGES = {
    200 => "OK",
    201 => "Created",
    202 => "Accepted",
    204 => "No Content",
    301 => "Moved Permanently",
    302 => "Moved Temporarily",
    304 => "Not Modified",
    400 => "Bad Request",
    401 => "Unauthorized",
    403 => "Forbidden",
    404 => "Not Found",
    500 => "Internal Server Error",
    501 => "Not Implemented",
    502 => "Bad Gateway",
    503 => "Service Unavailable"
  }.freeze

  attr_reader :status, :headers

  def initialize(status = 200, headers = [])
    @status = status
    @headers = headers
  end

  def write_to(socket)
    socket.write response_line
    headers.each do |header|
      socket.write "#{header}\r\n"
    end
  end

  def response_line
    "HTTP/1.0 #{status} #{MESSAGES[status]}\r\n"
  end
end
