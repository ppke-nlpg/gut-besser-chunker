#!/usr/bin/python3
# -*- coding: utf-8, vim: expandtab:ts=4 -*-

from collections import Counter
import sys
import os.path

if len(sys.argv) == 1:
    print('USAGE: {0} [file,]+ file'.format(sys.argv[0]), file=sys.stderr)
    print("Every file must have the labels as last field!", file=sys.stderr)
    sys.exit(1)

fh = []
for f in sys.argv[1:]:
    if os.path.exists(f):
        fh.append(open(f, encoding='UTF-8'))

no_of_voters = len(fh)
for i, lines in enumerate(zip(*fh)):
    if len(lines[0].strip()) == 0:
        print()
    else:
        out_line = lines[0].strip()  # This is needed for output
        gold = out_line.split()[-2]
        out_lines = []
        vote = Counter()
        for ind in range(no_of_voters):
            label = lines[ind].strip().split()[-1]
            out_lines.append(label)
            vote[label] += 1  # Vote for the label...

        chunk_max, maximum = max(sorted(vote.items()), key=lambda x: x[1])  # And the winner is...
        count_of_max = Counter(vote.values())[maximum]
        votes = ' '.join(out_lines[1:])
        if count_of_max > 1:
            print('Tie({0})'.format(count_of_max), out_line, votes, gold, chunk_max, '!', file=sys.stderr)
        print(out_line, votes, gold, chunk_max)
