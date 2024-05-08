#!/bin/bash

START="<!-- START_QUOTE -->"
END="<!-- END_QUOTE -->"

# sed -n '/'"$START"'/,/'"$END"'/{//!p}' README.md
# sed -n '/START_QUOTE/,/END_QUOTE/{//!p}' README.md

# Get the quote of the day from zenquotes api
ZENQUOTE=$( curl -s https://zenquotes.io/api/today | jq -r '.[0]' )
QUOTE=$( echo $ZENQUOTE | jq -r '.q' )  
AUTHOR=$( echo $ZENQUOTE | jq -r '.a' ) 
DISPLAY=' \
  > “'"$QUOTE"'” \
  > \
  > *- '"$AUTHOR"' -*\n'

# sed multiline replacement between 2 patterns https://fahdshariff.blogspot.com/2012/12/sed-mutli-line-replacement-between-two.html
sed -n -e '/START_QUOTE/{              # when "START_QUOTE" is found
            p                       # print
            :a                      # create a label "a"
            N                       # store the next line
            /END_QUOTE/!ba          # goto "a" and keep looping and storing lines until "END_QUOTE" is found
           # N                      # store the line containing "END_QUOTE"
            s/.*\n/'"$DISPLAY"'\n/  # replace the content
        }
        p' -i README.md                # print

# one line version
# sed -n '/START_QUOTE/{p;:a;N;/END_QUOTE/!ba;s/.*\n/'"$DISPLAY"'\n/};p' README.md