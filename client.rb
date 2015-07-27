require "./request"
require "./http_error"

class Client < Struct.new(:server, :socket)
  def handle_request
    begin
      parse_request.send_response(server, socket)

    rescue HTTPError => e
      Response.new(e.status).write_to socket

    ensure
      close
    end
  end

  def parse_request
    Request.parse(server, socket)
  end

  def close
    socket.close
  end
end
