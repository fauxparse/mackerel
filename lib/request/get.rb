class Request::Get < Request
  def send_response(server, socket)
    response = Response.from(server, uri)
    response.get(socket)
  end
end
