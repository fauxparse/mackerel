require "#{File.dirname(__FILE__)}/head"
require "mime/types"

class Request::Get < Request::Head
  MEGABYTE = 1_048_576
  INDEX_FILES = %w(index.html index.htm)

  def send_response(server, socket)
    filename = File.expand_path "." + uri, server.root

    if File.exist? filename
      if filename =~ /^#{server.root}(?:\/.*)?$/
        if File.directory? filename
          write_directory_listing_to socket, filename
        else
          pipe_regular_file_to socket, filename
        end
      else
        send_error_response socket, 403, "Access to #{filename} is forbidden."
      end
    else
      send_error_response socket, 404, "I couldn’t find #{filename}."
    end
  end

  def pipe_regular_file_to(socket, filename)
    begin
      File.open(filename) do |file|
        headers = [
          "Content-Length: #{File.size(filename)}",
          "Content-Type: #{mime_type(filename)}"
        ]

        Response.new(200, headers).write_to(socket) do
          read_file_in_chunks(file) do |bytes|
            socket.write bytes
          end
        end

        file.close
      end

    rescue Errno::EACCES
      send_error_response socket, 403, "Access to #{filename} is forbidden."
    end
  end

  def write_directory_listing_to(socket, directory)
    INDEX_FILES.each do |filename|
      index_file = File.join directory, filename
      if File.exist? index_file
        return pipe_regular_file_to socket, index_file
      end
    end

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

  def read_file_in_chunks(file, chunk_size = MEGABYTE)
    yield f.read(chunk_size) until f.eof?
  end
end
