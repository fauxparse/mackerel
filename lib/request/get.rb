class Request::Get < Request
  def send_response(server, socket)
    Response.from(server, uri).get(socket)
  end
end
