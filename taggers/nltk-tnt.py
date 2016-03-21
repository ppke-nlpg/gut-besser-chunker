#!/usr/bin/python3
# -*- coding: utf-8, vim: expandtab:ts=4 -*-

# Tag sentences with TnT
# Parameters:
#     a) data in 'WORD POS CHUNK' format (CoNLL-2000 format with any chunk type)
#     b) W_s set: one word per line (anything, but first column is ignored)
#     c) Lexicalization Type (default: Full):
#         c1) Full: if word in W_s than word+POS+chunk else POS+chunk
#         c2) Just words: if word in W_s than word+POS+chunk else chunk
#         c3) None: chunk (Nothing is done)
# Output: word pos-tag chunk-tag (format either words-pos words-pos-chunk or word pos pos-chunk or word pos chunk)

from nltk.tag import tnt
import sys

if len(sys.argv) != 6:
    print('USAGE: {0} train.file test.file output.file temp.dir pos.field'.format(sys.argv[0]), file=sys.stderr)
    sys.exit(1)

posField = int(sys.argv[5]) - 1

with open(sys.argv[1], encoding='UTF-8') as FP_train,\
     open(sys.argv[2], encoding='UTF-8') as FP_test,\
     open(sys.argv[3], 'w', encoding='UTF-8') as FP_out:
    # XXX Unk not handled...
    # In Brant's version the default is:
    # sparse data : linear interpolation
    # unknown mode: statistics of singletons
    # using suffix trie up to length 10
    # case of characters is significant (Handled)
    tagger = tnt.TnT(C=True)
    sents = []
    sent = []
    print("Adding sentences...", file=sys.stderr)
    for line in FP_train:
        line = line.strip().split()
        if len(line) == 0:
            sents.append(sent)
            sent = []
        else:
            sent.append((line[posField], line[-1]))
    print("Training...", file=sys.stderr)
    tagger.train(sents)

    print("Tagging...", file=sys.stderr)
    sent = []
    lines = []
    for line in FP_test:
        line = line.strip()
        lineSplitted = line.split()
        if len(lineSplitted) == 0:
            for (_, label), fullLine in zip(tagger.tag(sent), lines):
                print(fullLine, label, file=FP_out)
            print('', file=FP_out)
            sent = []
            lines = []
        else:
            sent.append(lineSplitted[posField])
            lines.append(line)
    for (_, label), fullLine in zip(tagger.tag(sent), lines):
        print(fullLine, label, file=FP_out)
    print('', file=FP_out)
