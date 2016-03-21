#!/bin/bash
# -*- coding: utf-8, vim: expandtab:ts=4 -*- 

realpath="`realpath $0`"
abspath="`dirname $realpath`"

if [ $# -ne 4 ]; then
     echo "USAGE: $0 FROM.format TO.format input.file output.file !" >&2
     exit 1
fi

fromFormat="$1"
toFormat="$2"
inputFile="$3"
outputFile="$4"

if [ "$fromFormat" == "IOBES" -o "$fromFormat" == "SBIEO" -o "$toFormat" == "IOBES" -o "$toFormat" == "SBIEO" ]; then
     echo "IOBES or SBIEO not supported !" >&2
     exit 2
fi

if [ "$fromFormat" == "$toFormat" ]; then
     echo "Validating not supported !" >&2
     exit 2
fi

conv="$abspath/to$toFormat/from$fromFormat.pl"
len=`cat "$inputFile" | wc -l`
# sed -r 's/^\s+$//' -> Clean up newlines
cat "$inputFile" | paste -d' ' <(yes | head -n$len) - | sed 's/^y $//' | "$conv" | sed -r -e 's/^\s+$//' \
-e 's/ \[]-([^ ]+)$/ S-\1/' -e 's/ \[-([^ ]+)$/ B-\1/' -e 's/ ]-([^ ]+)$/ E-\1/' > "$outputFile"

