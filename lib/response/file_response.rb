require "mime/types"

class Response::FileResponse < Response
  MEGABYTE = 1_048_576

  attr_reader :filename

  def initialize(filename, status = 200, headers = [])
    @filename = filename
    super status, headers
  end

  def headers
    super + [
      "Content-Length: #{File.size(filename)}",
      "Content-Type: #{mime_type(filename)}"
    ]
  end

  def head(socket, &block)
    begin
      File.open(filename) do |file|
        write_to(socket) { yield file }
        file.close
      end
    rescue Errno::EACCES
      raise new HTTPError, 403
    end
  end

  def get(socket)
    head(socket) do |file|
      read_file_in_chunks(file) { |bytes| socket.write bytes }
    end
  end

  def mime_type(filename)
    (MIME::Types.type_for(filename).first || default_mime_type).to_s
  end

  def default_mime_type
    @default_mime_type ||= MIME::Types["text/plain"]
  end

  def self.from_file(filename, root)
    new filename, 200
  end

  private

  def read_file_in_chunks(file, chunk_size = MEGABYTE)
    yield file.read(chunk_size) until file.eof?
  end
end
