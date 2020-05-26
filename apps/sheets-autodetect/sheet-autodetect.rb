
#!/usr/bin/ruby

#fantastico: https://www.twilio.com/blog/2017/03/google-spreadsheets-ruby.html

#require "google_drive"
#require "socket"

puts 'ideona: debug con -d e fa for each tab, .. for each column, ... inspecting vcolumn 2-inf 99% are integer -> integer. e cosi via'
#

require 'bundler'
Bundler.require

VER = '2.0'

$prog_conf = {}
$user                = $prog_conf['user']
$pass                = $prog_conf['pass'] # GoogleSpreadsheet-specific
$default_spreadsheet = $prog_conf['default_spreadsheet'] rescue :eror
$default_gid         = $prog_conf['default_gid'] rescue 0
$description         = $prog_conf['description'] rescue 'Descriptio non datur'


def usage()
  $stderr.puts "Usage: #{$0} [spreadsheet_id] [worksheet_id]"
  $stderr.puts "   ie: #{$0} #{$default_spreadsheet} #{$default_gid} # #{$description}"
  exit 3
end

def main
  usage unless ARGV.size == 3

  doc_friendly_name = ARGV[0]
  doc_id       = ARGV[1]
  worksheet_id = ARGV[2].to_i rescue $default_gid
  url = "https://docs.google.com/a/google.com/spreadsheet/ccc?key=#{doc_id}#gid=#{worksheet_id}"

  begin
    #$session = GoogleDrive.login($user,$pass)
    $session = GoogleDrive::Session.from_service_account_key("aj-config.json")
    spreadsheet = $session.spreadsheet_by_title("Alessandro Peso e altro")
  rescue
    puts "$0 v#{VER} Some error in logging in as '#{$user}' // '#{$pass.to_s.gsub(/./, '*')}'"
    puts "Error: #{$!}"
    exit 1
  end

  # First worksheet of
  begin
    ws = $session.spreadsheet_by_key(doc_id).worksheets[worksheet_id]
  rescue
    puts "$0 v#{VER}: Some error in connecting to the Excel '#{doc_id}' as '#{$user}'"
    puts "Error: #{$!}"
    exit 2
  end

  # Gets content of A2 cell.
  p "test (2,1):"
  p ws[2, 1]  #==> "hoge"


  # Dumps all cells.
  $stderr.puts "Dumping document Rows/Cols: #{ws.num_rows}x#{ws.num_cols}x"
  $stderr.puts  "================================================================================"
  ws.rows.each do |row|
    puts row.join("\t")
  end
  $stderr.puts  "================================================================================"
  $stderr.puts "#For curiosity, take a look here: #{url}"
end


main()


