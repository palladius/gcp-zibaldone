require 'sinatra'

version = "1.2"

set :bind, '0.0.0.0'

get '/' do
  color = ENV['COLOR']   || 'gray today.. but set up ENV[COLOR] to add hope'
  target = ENV['TARGET'] || 'World'
  "<h1>Cloud Run on ruby2.5</h1>\nHello #{target} from Riccardo v#{version}!<br>\nMy favorite color is: <b>#{color}</b>\n"
end
