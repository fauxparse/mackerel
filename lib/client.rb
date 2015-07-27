require_relative "./request"
require_relative "./http_error"

class Client < Struct.new(:server, :socket)
  def handle_request
    begin
      parse_request.send_response server, socket

    rescue HTTPError => e
      Response.new(e.status).write_to(socket) do
        socket.write e.message
      end

    ensure
      close
    end
  end

  def parse_request
    Request.parse server, socket
  end

  def close
    socket.close
  end
end
