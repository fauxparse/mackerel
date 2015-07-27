class Request::Head < Request
  def send_response(server, socket)
    Response.from(server, uri).head(socket)
  end
end
