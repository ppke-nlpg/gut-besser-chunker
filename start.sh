#!/bin/bash
# -*- coding: utf-8, vim: expandtab:ts=4 -*- 

realpath="`realpath $0`"
abspath="`dirname $realpath`"

# Colors: http://stackoverflow.com/a/5947802
LBLUE='\033[1;34m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color


# Clean up
./clean.sh

# Avoid crash (CRFSuite don't like :, TNT don't like %)
cat ./data/train.txt | sed -e 's/:/__COLON__/g' -e 's/%/__PERCENT__/g' > train_safe.txt
cat ./data/test.txt | sed -e 's/:/__COLON__/g' -e 's/%/__PERCENT__/g' > test.txt


# Make devel set and training set from training set...
./separate_devel_and_train.py train_safe.txt devel.txt train_new.txt

# Make freq table for lexicalisation
./doWCH.py devel.txt > wch.txt

# Convert training set to each format
mkdir converted
./conv_before_train.sh IOB2 ./train_new.txt converted
./conv_before_train.sh IOB2 test.txt converted

# All converter do the same on the starting input
rm converted/*{corenlp,ss05}*

# Lexicalise all...
# In all kind of ways " " -> Full, --just-words --none
for opt in " " "--none" "--just-words"
do
    lexSuff="${opt/--/}.lex"
    lexSuff="${lexSuff/ /full}"
    for name in `ls converted | grep -v 'valid$' | grep -v '\.lex$'`
    do
        printf "${LBLUE}"
        echo "Runing ./lexicalise.py \"$abspath/converted/$name\" wch.txt $opt > \"$abspath/converted/$name.$lexSuff\" :"
        printf "${NC}"
        ./lexicalise.py "$abspath/converted/$name" wch.txt $opt > "$abspath/converted/$name.$lexSuff"
        printf "${LBLUE}"
        echo "Runing ./lexicalise.py \"$abspath/converted/$name\" wch.txt $opt > \"$abspath/converted/$name.$lexSuff\" :"
        printf "${NC}"
        ./lexicalise.py "$abspath/converted/$name" wch.txt $opt > "$abspath/converted/$name.$lexSuff"
        if [ $? -eq 0 ]; then printf "${GREEN}Done!${NC}"; echo; fi
    done
done

# XXX PurePOS to be added
declare -A taggers=(
              [tnt]='tnt.sh              '
         [nltk-tnt]='nltk-tnt.py         '
   [huntag3-bigram]='HunTag3-bigram.sh   '
  [huntag3-trigram]='HunTag3.sh          '
 [huntag3-crfsuite]='HunTag3-CRFsuite.sh '
[crfsuite-official]='CRFsuite-official.sh'
)

# Train and tag with each tagger
mkdir temp
rm temp/Makefile
posField=2
i=1
for opt in "--just-words" "--none" " "
do
    lexSuff="${opt/--/}.lex"
    lexSuff="${lexSuff/ /full}"
    if [[ "$lexSuff" == "none.lex" ]]; then
        omit="AAAA"
    else
        omit="huntag3"  # XXX TEST
    fi
    for name in `ls converted | grep "$lexSuff\$" | grep 'train_new.txt'`
    do
        testName=${name/train_new/test}  # replaces train_new -> test
        trainFile=`realpath $abspath/converted/$name`
        testFile=`realpath $abspath/converted/$testName`
        outputFile=`realpath $abspath/converted/$testName`
        tempDir=`realpath $abspath/temp`
        posField="$posField"
        for key in "${!taggers[@]}"
        do
            if [[ ! $key =~ ^$omit ]]; then
                echo -e "$i:\n\t$abspath/taggers/${taggers[$key]} \"$trainFile\" \"$testFile\" \"$outputFile.$key.tagged\" \"$tempDir\" \"$posField\"\n" >> "$tempDir/Makefile"
                i=$((i+1))
            else
                echo "Omiting $regex* because long running time !"
            fi
        done
        if [ $? -eq 0 ]; then printf "${GREEN}Done!${NC}"; echo; fi
    done
done
i=$((i-1))

echo -n 'all: ' > Makefile
seq -s ' ' 1 $i >> Makefile
echo >> Makefile
cat temp/Makefile >> Makefile
make -j 8

# Delexicalise... (and eval solely without voting)

for name in `ls converted | grep '\.tagged$'`
do
    printf "${LBLUE}"
    echo "Runing ./delexicalise.py \"$abspath/converted/$name\" > \"$abspath/converted/$name.delex\" :"
    printf "${NC}"
	./delexicalise.py "$abspath/converted/$name" | sed 's/\t/ /g' > "$abspath/converted/$name.delex"
	echo "$abspath/converted/$name.delex:"
	cat "$abspath/converted/$name.delex" | sed 's/[^ ]*+//g' | ./conlleval.pl	
done

echo "FINISHED!"

exit 0
# To be developed...

# Vote...
for case in `ls converted | grep '\.tagged\.delex$' | sed -e 's/\.tagged\.delex$//' .e 's/test\.[^.]*.IOB2\.//' | sort | uniq`  # These are the cases (taggers)
do
    ./voteN.py test.*.IOB2.$case.tagged.delex > "$abspath/converted/test.balazs.IOB2.$case.tagged.delex.voted"  # All format of a tagger voted

# Eval...
cat "$abspath/converted/test.balazs.IOB2.$case.tagged.delex.voted" | cut -d ' ' -f1-3 | paste -d ' ' - <(cat "$abspath/converted/test.balazs.IOB2.$case.tagged.delex.voted" | rev | cut -d' ' -f1 | rev)  | ./conlleval.pl
done
