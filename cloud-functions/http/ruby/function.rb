require 'json'

# Responds to any HTTP request.
class HelloWorld

  # @param req [Rack::Request] HTTP request context.
  def initialize(req)
    @req = req
  end

  # Calls the function. Returns one of the following:
  # @return [string] The message parameter from the query string or 'Hello World!'.
  # @return [hash] The JSON encoded "message" field in the body.
  def call
    msg = 'Hello World (send me a :message via JSON for me to return that instead)!'
    msg = msg + "\n color=#{ENV["color"]}" if ENV["color"]
    msg = msg + " \nregion=#{ENV["region"]}" if ENV["region"]
    msg += "-- by your GCF Ruby2.5alpha"
    if @req.params.key?('message')
      msg += "message: ;;;" + @req.params['message'] + ";;;"
    elsif @req.body.size == 0 # .isEmpty?
      json = JSON.parse(@req.body.read)
      msg = json['message'] if json.key?('message')
    end
    msg
  end
end
