#!/bin/bash
# -*- coding: utf-8, vim: expandtab:ts=4 -*- 

for REP in "IOB1" "IOB2" "IOE1" "IOE2" "IOBES" "OC"
    do
    for LEX in "none" "just-words" "full"
    do
        echo "${REP}.${LEX}:"
        ./voteN.py CRFSuite-official/test.txt.balazs.IOB2.${REP}.${LEX}.lex.crfSuite.tagged.delex \
                                 lex/test.txt.balazs.IOB2.${REP}.${LEX}.lex.tnt.tagged.delex \
                                 lex/test.txt.balazs.IOB2.${REP}.${LEX}.lex.nltk-tnt.tagged.delex \
                                 lex/test.txt.balazs.IOB2.${REP}.${LEX}.lex.huntag3-trigram.tagged.delex \
                                 lex/test.txt.balazs.IOB2.${REP}.${LEX}.lex.huntag3-crfsuite.tagged.delex \
                                 lex/test.txt.balazs.IOB2.${REP}.${LEX}.lex.huntag3-crfsuite.tagged.delex \
                             purepos/test.txt.balazs.IOB2.${REP}.${LEX}.lex.2.purepos.tagged.delex \
            | ./conlleval.pl
    done
done
