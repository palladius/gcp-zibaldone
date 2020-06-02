LIbrary im using:

Docs: 
https://www.rubydoc.info/github/gimite/google-drive-ruby/GoogleDrive/Spreadsheet#add_worksheet-instance_method

# problems

Detect type from string seems the hardest part.

* Guy did it in Java: https://stackoverflow.com/questions/13314215/java-how-to-infer-type-from-data-coming-from-multiple-sources

# Rails types

integer
primary_key
decimal (for currency)
float
boolean
binary
string
text
date
time
datetime

for text, we can use the STRLEN (like: >15 is TEXT below 15 is string. Just an idea.)