#!/bin/bash
# -*- coding: utf-8, vim: expandtab:ts=4 -*-

realpath="`realpath $0`"
abspath="`dirname $realpath`"

# Colors: http://stackoverflow.com/a/5947802
LBLUE='\033[1;34m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

declare -A converters=(
[balazs]='conv_iob_balazs'
# [pisti]='conv_iob_pisti'
[ss05]='conv_iob_ss05'
[corenlp]='conv_iob_corenlp'
)

if [ $# -ne 4 ]; then
     echo 'Convert input file in a specific input format with all converter to all output format !' 
     echo "USAGE: $0 input.format input.file output.dir temp.dir" >&2
     echo 'Valid labelsets: IOB1, IOB2, IOE1, IOE2, IOBES, OC !' >&2
     exit 1
fi

inputFormat=$1
inputFile=$2
baseInputFile=`basename $2`
outputDir=`realpath $3`
tempDir=`realpath $4`


for outFormat in "IOB1" "IOB2" "IOE1" "IOE2" "IOBES" "OC"
do
    for key in "${!converters[@]}"
    do
        if [[ "$outFormat" != "$inputFormat" ]]; then
          # Convert...
            cat "$inputFile" | cut -d' ' -f1-3 > "$tempDir/$baseInputFile.gold"
            $abspath/converters/${converters[$key]}/run.sh $inputFormat $outFormat "$tempDir/$baseInputFile.gold" "$tempDir/$baseInputFile.$key.$inputFormat.$outFormat.gold"
            res=$?
            if [ $res -eq 2 ]; then continue; fi
            if [ $res -eq 1 -o $res -gt 2 ]; then exit $?; fi
            cat "$inputFile" | cut -d' ' -f1-2,4 > "$tempDir/$baseInputFile.auto"
            $abspath/converters/${converters[$key]}/run.sh $inputFormat $outFormat "$tempDir/$baseInputFile.auto" "$tempDir/$baseInputFile.$key.$inputFormat.$outFormat.auto"
            res=$?
            if [ $res -eq 1 -o $res -gt 2 ]; then exit $?; fi
            cat "$tempDir/$baseInputFile.$key.$inputFormat.$outFormat.auto" | cut -d' ' -f3 | paste -d ' ' "$tempDir/$baseInputFile.$key.$inputFormat.$outFormat.gold" - | sed 's/^ *$//' > "$outputDir/$baseInputFile.$key.$inputFormat.$outFormat"
        else
            if [[ "$key" == "balazs" ]]; then
                # Validate...
                $abspath/converters/${converters[$key]}/run.sh $inputFormat $outFormat "$inputFile" "$outputDir/$baseInputFile.$key.$inputFormat.$outFormat.valid"
                res=$?
                if [ $res -eq 1 -o $res -gt 2 ]; then exit $res; fi
            fi
            # Copy...
            echo "Copying: \"$inputFile\" to \"$outputDir/$baseInputFile.$key.$inputFormat.$outFormat\""
            cp "$inputFile" "$outputDir/$baseInputFile.$key.$inputFormat.$outFormat"
            if [ $? -eq 0 ]; then printf "${GREEN}Done!${NC}"; echo; fi
        fi
    done
done
