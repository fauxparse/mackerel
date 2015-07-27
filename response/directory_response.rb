class Response::DirectoryResponse < Response
  INDEX_FILES = %w(index.html index.htm)

  attr_reader :directory, :root

  def initialize(directory, root)
    super 200, []
    @directory = directory
    @root = root
  end

  def headers
    super + ["Content-Length: #{html.length}"]
  end

  def head(socket, &block)
    write_to socket, &block
  end

  def get(socket)
    head(socket) { socket.write html }
  end

  def files
    @files ||= Dir.entries(directory).sort
  end

  def html
    @html ||= header + file_list + footer
  end

  def header
    "<html><body><h1>Files in #{relative_path(directory)}</h1>"
  end

  def footer
    "</body></html>"
  end

  def file_list
    entries = files.map do |file|
      path = relative_path file
      "<li><a href=\"#{path}\">#{File.basename(path)}</a></li>"
    end

    "<ul>\n#{entries.join("\n")}\n</ul>\n"
  end

  def relative_path(file)
    file.sub(/^#{root}/, "") + "/"
  end

  def self.from_directory(uri, root)
    index_file(uri, root) || generated_index(uri, root)
  end

  def self.index_file(filename, root)
    INDEX_FILES.each do |f|
      index_filename = File.join(filename, f)

      if File.exist? index_filename
        return FileResponse.new(index_filename)
      end
    end

    new filename, root
  end
end
