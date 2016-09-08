#!/bin/bash

# Create PurePOS format from vertical file. Lemma will be made equivalent with the word in order to avoid guessing.
# The format varibale can switch between the various input transformations:
# (1) The input is the token
# (2) The input is the POS tag
# (3) The input is the combination of the token and the post tag (only this is featured in the paper)

# Swithces input format. 1: word; 2: tag; 3: word@tag [default 3]
format=3

PATHTOPUREPOS=""

# Train set contains the IOB tag
function vert2pureposTrain(){
	gawk -F' ' -v format=$1 'BEGIN{tostring=""}{
		if ($0 == ""){
			print tostring;
			tostring=""
		}
		else{
			if (format == 1){
				word = $1
			}
			else if (format == 2){
				word = $2
			}
			else if (format == 3){
				word = $1 "@" $2
			}
			if (tostring==""){
				tostring = word "#" word "#" $3
			}
			else{
				tostring = tostring " " word "#" word "#" $3 
			}
		}
	}END{print tostring;}' 
}

# Test set does NOT contain the IOB tag
function vert2pureposTest(){
	gawk -F' ' -v format=$1 'BEGIN{tostring=""}{
		if ($0 == ""){
			print tostring;
			tostring=""
		}
		else{
			if (format == 1){
				word = $1
			}
			else if (format == 2){
				word = $2
			}
			else if (format == 3){
				word = $1 "@" $2
			}
			if (tostring==""){
				tostring = word
			}
			else{
				tostring = tostring " " word
			}
		}
	}END{print tostring;}' 
}

while [[ $# > 3 ]]
do
key="$1"
case $key in
    --format)
        shift
        format=$1
    ;;
    *)    # unknown option
        echo "--format <int>    1: word; 2: tag; 3: word@tag"
        echo "usage: $0 [--format <int>] <trainFile> <testFile> <outFile>"
        exit
    ;;
esac
shift  # past argument or value
done

trainFile=$1
testFile=$2
outFile=$3
outDir=$(dirname $(readlink -f $outFile))

if [ ! -d $outDir ]; then
	mkdir $outDir
fi
tempDir=$(mktemp -p $outDir -d "temp_XXXXX")

echo $tempDir

# escape "#" and "@" characters
sed -r "s#\##\&HASHMARKSYMBOL;#gi;s#@#\&ATSYMBOL;#gi" < $trainFile > $tempDir/train.orig &
sed -r "s#\##\&HASHMARKSYMBOL;#gi;s#@#\&ATSYMBOL;#gi" < $testFile > $tempDir/test.orig &
wait

# Convert input to purepos format both for train and for test
vert2pureposTrain $format < $tempDir/train.orig > $tempDir/train.purepos &
vert2pureposTest $format < $tempDir/test.orig > $tempDir/test.sent &
wait

# Train purepos model
java -jar ${PATHTOPUREPOS}purepos-2.1-dev.one-jar.jar train -m $tempDir/train.model -i $tempDir/train.purepos

# Run purepos on test set
java -jar ${PATHTOPUREPOS}purepos-2.1-dev.one-jar.jar tag -m $tempDir/train.model -i $tempDir/test.sent -o $tempDir/test.result.txt

# Result is augmented to the test file as the rightmost column
paste -d " " $testFile <(cat $tempDir/test.result.txt | sed -r "s#\$#\n#gi" | tr ' ' '\n' | tr "#" " " | cut -d ' ' -f3 ) > $outFile

# Thanks to László Laki for the code! ;)
