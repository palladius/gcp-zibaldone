require 'json'
#require 'rack'

# Responds to any HTTP request.
class RbHelloworld

  VERSION = "1.2"
  INTERESTING_FIELDS = %w{ color COLOR region REGION message MESSAGE HOSTNAME GIC USER USERNAME }
    
  # @param req [Rack::Request] HTTP request context.
  def initialize(req)
    @req = req
  end

  def add_msg(type, msg)
    "add_msg(type=#{type}): '#{msg}'\n"
  end

  # Calls the function. Returns one of the following:
  # @return [string] The message parameter from the query string or 'Hello World!'.
  # @return [hash] The JSON encoded "message" field in the body.
  def call
    msg = "Hi from RbHelloworld v.#{VERSION})!"
    msg += "\n1. send me a :message via JSON for me to return that instead)!"
    msg += "\n2. Also Im so smart I can actually detect a 'color'/'region' in ENV variables!"
    INTERESTING_FIELDS.each do |field|
      msg += "\n- #{field}=#{ENV[field]}" if ENV[field]
    end
    msg += "\n\n-- by your GCF Ruby2.5alpha"
    if @req.params.key?('message')
      msg += add_msg("Req.Param.Message", @req.params['message'])
    elsif @req.body.size == 0 # .isEmpty?
      json = JSON.parse(@req.body.read) rescue {'message' => "JSON Exception: #{$!}"}
      msg += add_msg("JSON", json['message']) if json.key?('message')
    end
    msg + "\n"
  end
end

def test_locally
  # test locally..
  print ENV['COLOR']
  if ENV['TERM'] == "xterm-256color" # or ENV['TEST-LOCALLY'] == "TRUE"
    require 'rack'
    #print "I presume you're in localhost. Testing code here. If I were less lazy, I'd create a second ruby file which calls the function.rb.."
    # taken from: https://stackoverflow.com/questions/17396611/what-is-the-env-variable-in-rack-middleware
    env = {
    "GATEWAY_INTERFACE" => "CGI/1.1",
    "PATH_INFO" => "/index.html",
    "QUERY_STRING" => "",
    "REMOTE_ADDR" => "::1",
    "REMOTE_HOST" => "localhost",
    "REQUEST_METHOD" => "GET",
    "REQUEST_URI" => "http://localhost:3000/index.html",
    "SCRIPT_NAME" => "",
    "SERVER_NAME" => "localhost",
    "SERVER_PORT" => "3000",
    "SERVER_PROTOCOL" => "HTTP/1.1",
    "SERVER_SOFTWARE" => "WEBrick/1.3.1 (Ruby/2.0.0/2013-11-22)",
    "HTTP_HOST" => "localhost:3000",
    "HTTP_USER_AGENT" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:26.0) Gecko/20100101 Firefox/26.0",
    "HTTP_ACCEPT" => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
    "HTTP_ACCEPT_LANGUAGE" => "zh-tw,zh;q=0.8,en-us;q=0.5,en;q=0.3",
    "HTTP_ACCEPT_ENCODING" => "gzip, deflate",
    "HTTP_COOKIE" => "jsonrpc.session=3iqp3ydRwFyqjcfO0GT2bzUh.bacc2786c7a81df0d0e950bec8fa1a9b1ba0bb61",
    "HTTP_CONNECTION" => "keep-alive",
    "HTTP_CACHE_CONTROL" => "max-age=0",
    "rack.version" => [1, 2],
    "rack.input" => "Answer is 42",
    "rack.multithread" => true,
    "rack.multiprocess" => false,
    "rack.run_once" => false,
    "rack.url_scheme" => "http",
    "HTTP_VERSION" => "HTTP/1.1",
    "REQUEST_PATH" => "/index.html"
    }
    req = Rack::Request.new(env)
    func = RbHelloworld.new(req)
    msg = func.call()
    print "= Msg from Cloud Function =\n\n#{msg}"
  end
end


test_locally()