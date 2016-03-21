#!/usr/bin/python3
# -*- coding: utf-8, vim: expandtab:ts=4 -*-

# Delexicalise (remove everything before the separator character (+) in the specified column (-1))
# Input: Tagged file last column (or else it specified in the commandline arguments)
#        is the chunk separated by '+' or specified separator.
# Output: Input line with stripped chunk
import sys


def make_delexicalisation(FP):
    for line in FP:
        words = line.strip().split()
        if len(words) == 0:  # blank line
                print()
        else:
            words[column] = words[column].split(sep)[-1]  # Last part of chunk
            print(' '.join(words))

if len(sys.argv) == 1:
    print('USAGE: {0} data [column number starts from 0, default: -1] [separator character default: +]'.format(
          sys.argv[0]), file=sys.stderr)
    sys.exit(1)

if len(sys.argv) == 3:
    print('Must specify column and separator too!'.format(sys.argv[0]), file=sys.stderr)
    sys.exit(1)

column = -1
sep = '+'
if len(sys.argv) == 4:
    column = int(sys.argv[2])
    sep = sys.argv[3]

data = sys.argv[1]
if data == '-':
    data = sys.stdin
    make_delexicalisation(data)
else:
    with open(data, encoding='UTF-8') as inFP:
        make_delexicalisation(inFP)
