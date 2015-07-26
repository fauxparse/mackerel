require "./request"
require "./http_error"

class Client < Struct.new(:socket)
  def handle_request
    begin
      parse_request.send_response

    rescue HTTPError => e
      Response.new(e.status).write_to socket

    ensure
      close
    end
  end

  def parse_request
    Request.parse(socket)
  end

  def close
    socket.close
  end
end
