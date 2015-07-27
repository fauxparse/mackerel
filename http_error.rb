class HTTPError < Exception
  attr_reader :status

  def initialize(status = 500)
    @status = status
    super Response::MESSAGES[status]
  end
end
