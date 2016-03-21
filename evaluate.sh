#!/bin/bash
# -*- coding: utf-8, vim: expandtab:ts=4 -*-

rm ties2.log
for targetRep in "IOB1" "IOB2" "IOE1" "IOE2" "IOBES" # "OC"
do
    for lex in "none" "just-words" "full"
    do
        for tagger in "tnt" "nltk-tnt" "huntag3-bigram" "huntag3-trigram" "huntag3-crfsuite" "crfSuite" "2.purepos" # "1.purepos" "3.purepos"
        do
            for conv in "balazs" "corenlp" # "ss05"
            do
                params=""
                for origRep in "IOB1" "IOB2" "IOE1" "IOE2" "IOBES" # "OC"
                do
                    echo "converted/test.txt.balazs.IOB2.${origRep}.${lex}.lex.${tagger}.tagged.delex.${conv}.${origRep}.${targetRep}"
                	converters/conv_iob_balazs/run.sh ${targetRep} ${targetRep} "converted/test.txt.balazs.IOB2.${origRep}.${lex}.lex.${tagger}.tagged.delex.${conv}.${origRep}.${targetRep}" - | grep -c "Invalid$"
                    params="$params converted/test.txt.balazs.IOB2.${origRep}.${lex}.lex.${tagger}.tagged.delex.${conv}.${origRep}.${targetRep}"
                done
                echo "$params"
                echo
                ./voteN.py $params 2>>ties2.log | tee "converted/test.txt.balazs.IOB2.${origRep}.${lex}.lex.${tagger}.tagged.delex.${conv}.${origRep}.${targetRep}.voted" | ./conlleval.pl
                echo
            done
        done
    done
done
