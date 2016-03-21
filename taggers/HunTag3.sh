#!/bin/bash
# -*- coding: utf-8, vim: expandtab:ts=4 -*-

realpath="`realpath $0`"
abspath="`dirname $realpath`"
huntagpath="$abspath/HunTag3/HunTag3/huntag.py"
huntagconfig="$abspath/HunTag3/HunTag3/configs/hunchunk.Just.krPatt.yaml"
order=3

if [ $# -ne 5 ]; then
     echo "USAGE: $0 train.file test.file output.file temp.dir pos.field  !" >&2
     exit 1
fi

trainfile="$1"
trainfileBase=`basename $1`
testfile="$2"
outputfile="$3"
tempdir="$4"
posField="$5"  # Needed for cut

if [ ! -f "$tempdir/$trainfileBase.model" ]; then
    # train:
    echo 'Train:' >&2
    "$huntagpath" train --cutoff 0 --config-file="$huntagconfig" --model="$tempdir/$trainfileBase" -i "$trainfile"
fi

if [ ! -f "$tempdir/$trainfileBase.$order.transmodel" ]; then
    # transmodel-train:
    echo 'Transmodel-train:' >&2
    "$huntagpath" transmodel-train --cutoff 0 --config-file="$huntagconfig" --model="$tempdir/$trainfileBase" --trans-model-order $order --trans-model-ext ".$order.transmodel" -i "$trainfile"
fi

# tag:
"$huntagpath" tag --cutoff 0 --config-file="$huntagconfig" --model="$tempdir/$trainfileBase" --trans-model-ext ".$order.transmodel" -i "$testfile" | sed 's/\t/ /g' > "$outputfile"
