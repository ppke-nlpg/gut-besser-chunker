#!/usr/bin/python3
# -*- coding: utf-8, vim: expandtab:ts=4 -*-

# Select the words that belong to certain chunks such as SBAR,PP and VP with
# high frequency in the trainning set
# Options: Frequency, POS-RE
# Input: original trainning data and converted file
# Output: frequency table (format: word-chunkType frequency)

import sys
import re
from collections import Counter
seen = Counter()

def make_freq_table(f):
    for line in f:
        line=line.strip()
        words1 = line.split()
        if 1 < len(words1) <= 3 and words1[2] != 'O':
            words2 = words1[2].split('-')  # with words that may contain hypen...
            temp = words1[0]+ '-' + words2[1]
            seen[temp]+=1

    for k, v in sorted(seen.items()):
        if v >= freq and regEx.search(k):
            print(k, v)

if len(sys.argv) == 1:
    print('USAGE: {0} data [freq] [POS-RE]'.format(sys.argv[0]), file=sys.stderr)
    sys.exit(1)

freq = 50
if len(sys.argv) == 3:
    freq = int(sys.argv[2])

# pick certain chunk NP,VP,PP,and ADVP
rex = '(NP|PP|VP|ADVP)$'  # AD(VP)
if len(sys.argv) == 4:
    freq = int(sys.argv[2])
    rex = sys.argv[3]

regEx = re.compile(rex)

data = sys.argv[1]
if sys.argv[1] == '-':
    data = sys.stdin
    make_freq_table(data)
else:
    with open(data, encoding='UTF-8') as f:
        make_freq_table(f)
