class Response::NotFoundResponse < Response
  attr_accessor :uri

  def initialize(uri)
    super 404
    @uri = uri
  end

  def get(socket)
    head(socket) do |file|
      socket.write "I couldn't find #{uri}"
    end
  end
end
