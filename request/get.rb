require_relative "../directory_listing.rb"
require "mime/types"

class Request::Get < Request
  MEGABYTE = 1_048_576
  INDEX_FILES = %w(index.html index.htm)

  def send_response(server, socket)
    filename = File.expand_path "." + uri, server.root

    if File.exist? filename
      if filename =~ /^#{server.root}(?:\/.*)?$/
        if File.directory? filename
          write_directory_listing_to socket, filename, server.root
        else
          write_regular_file_to socket, filename
        end
      else
        send_error_response socket, 403, "Access to #{filename} is forbidden."
      end
    else
      send_error_response socket, 404, "I couldn’t find #{filename}."
    end
  end

  def headers(filename)
    headers = [
      "Content-Length: #{File.size(filename)}",
      "Content-Type: #{mime_type(filename)}"
    ]
  end

  def write_regular_file_to(socket, filename)
    begin
      File.open(filename) do |file|
        Response.new(200, headers(filename)).write_to(socket) do
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

  def show_index_file(socket, directory, root)
    INDEX_FILES.each do |filename|
      index_file = File.join directory, filename
      if File.exist? index_file
        return write_regular_file_to socket, index_file
      end
    end

    false
  end

  def show_generated_index(socket, directory, root)
    DirectoryListing.new(directory, root).write_to socket
  end

  def write_directory_listing_to(socket, directory, root)
    show_index_file(socket, directory, root) || show_generated_index(socket, directory, root)
  end

  def mime_type(filename)
    (MIME::Types.type_for(filename).first || default_mime_type).to_s
  end

  def default_mime_type
    @default_mime_type ||= MIME::Types["text/plain"]
  end

  private

  def read_file_in_chunks(file, chunk_size = MEGABYTE)
    yield file.read(chunk_size) until file.eof?
  end
end
