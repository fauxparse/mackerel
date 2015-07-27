require "#{File.dirname(__FILE__)}/head"
require "mime/types"

class Request::Get < Request::Head
  MEGABYTE = 1_048_576

  def send_response(server, socket)
    filename = File.expand_path "." + uri, server.base_directory

    if File.exist? filename
      if File.directory? filename
        write_directory_listing_to socket, filename
      else
        pipe_regular_file_to socket, filename
      end
    else
      Response.new(404).write_to(socket) do
        socket.write "I couldn’t find #{filename}\r\n"
      end
    end
  end

  def pipe_regular_file_to(socket, filename)
    headers = [
      "Content-Length: #{File.size(filename)}",
      "Content-Type: #{mime_type(filename)}"
    ]

    Response.new(200, headers).write_to(socket) do
      read_file_in_chunks(filename) do |bytes|
        socket.write bytes
      end
    end
  end

  def write_directory_listing_to(socket, directory)
    Response.new.write_to(socket) do
      socket.write "#{directory} is a directory\r\n"
    end
  end

  def mime_type(filename)
    (MIME::Types.type_for(filename).first || default_mime_type).to_s
  end

  def default_mime_type
    @default_mime_type ||= MIME::Types["text/plain"]
  end

  private

  def read_file_in_chunks(filename, chunk_size = MEGABYTE)
    File.open(filename, "rb") do |f|
      yield f.read(chunk_size) until f.eof?
      f.close
    end
  end
end
