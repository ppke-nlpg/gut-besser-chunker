#!/bin/bash
# -*- coding: utf-8, vim: expandtab:ts=4 -*-

if [ $# -ne 5 ]; then
     echo "USAGE: $0 train.file test.file output.file temp.dir pos.field !" >&2
     exit 1
fi

trainfile="$1"
trainfileBase=`basename $1`
testfile="$2"
outputfile="$3"
tempdir="$4"
posField="$5"  # Needed for cut

rm -rf "$tempdir/$trainfile.*"  # Clean up for safety
# Output:  field -2 gold -1 auto 
echo "cat \"$trainfile\" | cut -d  ' ' -f $posField | paste -d ' ' - <(cat \"$trainfile\" | rev | cut -d' ' -f1 | rev) | sed 's/^ *$//' | tnt-para -o \"$tempdir/$trainfileBase\" -"
cat "$trainfile" | cut -d  ' ' -f $posField | paste -d ' ' - <(cat "$trainfile" | rev | cut -d' ' -f1 | rev) | sed 's/^ *$//' | tnt-para -o "$tempdir/$trainfileBase" -
echo "cat \"$testfile\" | cut -d' ' -f $posField | tnt -v 1 \"$tempdir/$trainfileBase\" - |  sed 's/.*\s//' | paste -d ' ' \"$testfile\" - | sed 's/^ *$//' > \"$outputfile\""
cat "$testfile" | cut -d' ' -f $posField | tnt -v 1 "$tempdir/$trainfileBase" - | sed 's/.*\s//' | paste -d ' ' "$testfile" - | sed 's/^ *$//' > "$outputfile"
echo '' >> "$outputfile"
