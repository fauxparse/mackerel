require_relative "./get"

class Request::Head < Request::Get
  def write_regular_file_to(socket, filename)
    Response.new(200, headers(filename)).write_to(socket)
  end

  def show_generated_index(socket, directory, root)
    DirectoryListing.new(directory, root).head socket
  end
end
