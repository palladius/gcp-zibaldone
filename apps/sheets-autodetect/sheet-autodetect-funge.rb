##################################################
# da https://github.com/gimite/google-drive-ruby

require "google_drive"
require "socket"

VERSION = "1.0"

def addSchemaWorksheet(ws)
  ws.add_worksheet("_schema")

  ws[2, 9] = "Hostname"
  ws[2, 9] = Socket.gethostname # B2
  ws[1, 10] = "CLI" # A2
  ws[2, 10] = ARGV.join(" ") # B2
  ws.save
end

def inspectSchemaByTab(ws, tab_id)
  arr = [] 
  railsGenString = "rails generate #{ws.title} TODO"
  (1..ws.num_cols).each do |col|
    p col

  end
  return railsGenString
end

def main
  # Creates a session. This will prompt the credential via command line for the
  # first time and save it to config.json file for later usages.
  # See this document to learn how to create config.json:
  # https://github.com/gimite/google-drive-ruby/blob/master/doc/authorization.md
  session = GoogleDrive::Session.from_config("credentials.json")

  # First worksheet of
  # https://docs.google.com/spreadsheet/ccc?key=pz7XtlQC-PYx-jrVMJErTcg
  # Or https://docs.google.com/a/someone.com/spreadsheets/d/pz7XtlQC-PYx-jrVMJErTcg/edit?usp=drive_web
  ws = session.spreadsheet_by_key("1pWqRWW3qhPfzjdmN0_D9Cz_D3fi0qv_fb1z2NeckSt8").worksheets[0]

  print "ws Title: #{ws.title}\n"
  print "ws Prop: #{ws.properties}\n"
  print "ws MaxSize: #{ws.max_rows}r %  #{ws.max_cols}c \n"
  print "ws EffectiveSize: #{ws.num_rows}r %  #{ws.num_cols}c \n"
  print "ws Spreado: #{ws.spreadsheet}\n"
  print "ws gid: #{ws.gid}\n"
  print "ws[2,1]: ", ws[2, 1]  #==> "hoge"  # Gets content of A2 cell.
  p "B2: ", ws.cell_name_to_row_col("B2")

  p ws.list[0]["Name"]

  # Changes content of cells.
  # Changes are not sent to the server until you call ws.save().

  # Dumps all cells.
  (1..ws.num_rows).each do |row|
    (1..ws.num_cols).each do |col|
      print ws[row, col], " | "
    end
    print "\n"
  end


  print inspectSchemaByTab(ws)
  #addSchemaWorksheet(ws)

  # Yet another way to do so.
  p ws.rows  #==> [["fuga", ""], ["foo", "bar]]

  # Reloads the worksheet to get changes by other clients.
  ws.reload
end

main