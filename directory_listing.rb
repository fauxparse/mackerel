require "./response"

class DirectoryListing < Struct.new(:directory, :root)
  def files
    @files ||= Dir.entries(directory).sort
  end

  def write_to(socket)
    Response.new(200, ["Content-Length: #{html.length}"]).write_to(socket) do
      socket.write html
    end
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
end
