##################################################
# da https://github.com/gimite/google-drive-ruby
# https://www.rubydoc.info/github/gimite/google-drive-ruby/GoogleDrive/Spreadsheet#add_worksheet-instance_method
# single tab API: https://www.rubydoc.info/github/gimite/google-drive-ruby/GoogleDrive/Worksheet#insert_rows-instance_method
# Colors: https://www.rubydoc.info/github/gimite/google-drive-ruby/GoogleDrive/Worksheet/Colors
# dark orange: Google::Apis::SheetsV4::Color.new(red: 0.9, green: 0.569, blue: 0.22)


require "google_drive"
require "socket"
require "rails"
require_relative "type_detector"

VERSION = "1.3"
$schema_tab_name = "_schema_v#{VERSION}_"
$trix_id = nil 
$schema_ws = nil


def appendToRow(ws, row_number, arr, opts={})
  print "appendToRow(#{ws.title},#{row_number},arr=#{arr})\n"
  col=1
  unless ws.class == GoogleDrive::Worksheet 
    raise "EXpecting a worksheet or a nice tshirt, instead I got: #{ws.class}"
  end
  arr.each{|el| 
    ws[row_number, col] = el
    col+=1
  }
  ws.save
end

def addSchemaWorksheet(ws, after_columns = 10)
  print "WS Class: #{ws.class}"
  unless ws.class == GoogleDrive::Worksheet 
    raise "EXpecting a worksheet or a nice tshirt, instead I got: #{ws.class}"
  end
  ws.reload
  schema_headers = %w{ Ix TabName Model RailsCommand, Notes }
  ws.set_background_color(1, 1, 1, schema_headers.size, GoogleDrive::Worksheet::Colors::DARK_GREEN_1)
  appendToRow(ws, 1, schema_headers )
  appendToRow(ws, 2, %w{ 1 Blahs BlahSingolare rails_stika_todo } )
  #appendToRow(ws, 3, %w{ 2 Cars Car AtPIasriaBelo } )
  ws.save
  ws[1, after_columns] = "Hostname"
  ws[2, after_columns] = Socket.gethostname # B2
  ws[1, after_columns+1] = "CLI" # A2
  ws[2, after_columns+1] = ARGV.join(" ") # B2
  ws[1, after_columns+2] = "Cmd" # A2
  ws[2, after_columns+2] = $0 # inspectSchemaByTab(ws)
  ws.save
  ws.set_background_color(1, after_columns, 2, 3, GoogleDrive::Worksheet::Colors::DARK_YELLOW_1)
  ws.save
end

def addToSchemaWsRelevantInfo(ix, ws, schema_ws)
  #print "addToSchemaWsRelevantInfo( #{ix}, #{ws.title}, #{schema_ws.title})\n" 
  schemaCommand = inspectSchemaByTab(ws)
  model_name = ws.title.downcase().singularize()
  notes = "Model with #{schemaCommand.split(' ').count} entities and circa #{ws.num_rows-1} values."
  appendToRow(
    schema_ws, 
    ix+3, # TODO(ricc): put 2 instead in prod. starts from 2: 1 is schema, 2 is a test
    [ix, ws.title, model_name, schemaCommand, notes ] 
  )

end

def dump_all_cells(ws)
  (1..ws.num_rows).each do |row|
    (1..ws.num_cols).each do |col|
      print ws[row, col], " | "
    end
    print "\n"
  end
end

def inferColTypeByColumn(colname, arr)
  # detect from title
  return "date" if %w( data date ).include?(colname)
  # nope - detect from majority of fields
  votes={}
  arr.each { |el|
    votes[:bool] +=1 if el.in?(%w(true false)) 
    # Float: https://stackoverflow.com/questions/1034418/determine-if-a-string-is-a-valid-float-value
    votes[:float] +=1 if el =~ /^\s*[+-]?((\d+_?)*\d+(\.(\d+_?)*\d+)?|\.(\d+_?)*\d+)(\s*|([eE][+-]?(\d+_?)*\d+)\s*)$/
    #print "#DEB# Inspecting #{el}: #{el.class}\n"
  }
  winner = 'todo'
  print "#DEB# Winner '#{winner}' for '#{colname}'. Votes: #{votes}\n"

  "string42"
end


def inspectSchemaByTab(ws)
  arr = [] 
  modelname = ws.title.singularize()
  railsGenString = "rails generate scaffold #{modelname}"
  (1..ws.num_cols).each do |col|
    colname = ws[1, col]
    print col, colname, "\n"
    col_type="string" # TODO https://support.google.com/docs/answer/3267375
    col_values = (0..(ws.num_rows-2)).map{ |i| ws.list[i][colname] } # -2: array is 0..-1 and first is title :)
    print "#DEB# column values: #{col_values}\n"
    col_type = inferColTypeByColumn(colname, col_values)
    railsGenString += " #{ws[1, col]}:#{col_type}"
  end
  return railsGenString
end

def print_worksheet_headers(ws, description)
  print "\n== #{ws.class}: '#{ws.title}' (#{description}) ==\n"
  print "ws gid: #{ws.gid}\n"
  #print "ws Title: #{ws.title}\n"
  #print "ws Properties: #{ws.properties}\n"
  #print "ws MaxSize (RxC): #{ws.max_rows}x#{ws.max_cols}\n" # not very relevant
  print "ws EffectiveSize (RxC): #{ws.num_rows}x#{ws.num_cols}\n"
  #print "ws Spreado: #{ws.spreadsheet}\n"
  #print "ws sheet_id (same as above): #{ws.sheet_id}\n"
  print "ws column[name]: first value: #{ws.list[0]["Name"] rescue 'NoNameApparentlyError'}\n"
  print "ws First Row (headers): #{ws.rows[0]}\n"
  
end

def usage(explaination='')
  print "Usage: $0 <trix_id>"
  print "  Further explaination: #{explaination}"
  exit(42)
end

def main
  # Creates a session. This will prompt the credential via command line for the
  # first time and save it to config.json file for later usages.
  # See this document to learn how to create config.json:
  # https://github.com/gimite/google-drive-ruby/blob/master/doc/authorization.md
  session = GoogleDrive::Session.from_config("credentials.json")

  if (ARGV[0]) 
    $trix_id = ARGV[0]
  else
    usage "Missing ARGV with TrixId"
  end
  # First worksheet of
  # https://docs.google.com/spreadsheet/ccc?key=pz7XtlQC-PYx-jrVMJErTcg
  # Or https://docs.google.com/a/someone.com/spreadsheets/d/pz7XtlQC-PYx-jrVMJErTcg/edit?usp=drive_web
  trix = session.spreadsheet_by_key($trix_id)
  #ws = trix.worksheets[0]
  my_worksheet_tabs = session.spreadsheet_by_key($trix_id).worksheets
  p "my_worksheet_tabs: #{my_worksheet_tabs}"

  tab_titles = my_worksheet_tabs.map{|ws| ws.title }
  puts "Titles: #{tab_titles}" 
  if tab_titles.include?($schema_tab_name) 
    p 'Schema already existing!'
    schema_index = tab_titles.index($schema_tab_name)
    $schema_ws = my_worksheet_tabs[schema_index]
  else 
    p 'Schema NOT existing: creating!' 
    $schema_ws  = trix.add_worksheet($schema_tab_name)
  end

  print_worksheet_headers($schema_ws, "Schema WS first")
  addSchemaWorksheet($schema_ws, 7)

  ix = 0
  my_worksheet_tabs.select{|ws| ws.title =~ /^[A-Z]/ }.each{|ws| 
    #print_worksheet_headers(ws, "generic model (must start with capital letter)")
    #print "Title(#{ws.title}) Matcha? #{ws.title =~ /^[A-Z]/}\n"
    #print inspectSchemaByTab(ws)
    #addSchemaWorksheet(ws)
    addToSchemaWsRelevantInfo(ix, ws, $schema_ws)
    ix +=1 
  }

  #print "ws[2,1]: ", ws[2, 1]  #==> "hoge"  # Gets content of A2 cell.
  #p "B2: ", ws.cell_name_to_row_col("B2")


  # Changes content of cells.
  # Changes are not sent to the server until you call ws.save().

  #dump_all_cells(ws)

  # Yet another way to do so.
  #p ws.rows  #==> [["fuga", ""], ["foo", "bar]]

  # Reloads the worksheet to get changes by other clients.
  #ws.reload
end

main