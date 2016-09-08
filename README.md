# Gut, Besser, Chunker
The program used in the paper 'Gut, Besser, Chunker – Selecting the best models for text chunking with voting' by Balázs Indig and István Endrédy

## Prerequisites

- data folder: train.txt and test.txt (The [CoNLL-2000 data](http://www.cnts.ua.ac.be/conll2000/chunking/))
- CRFsuite installed and (crfsuite and chunking.py in path)
- TnT installed and in path
- All git submodules inited and updated (./postClone.sh)
- Python3, JRE 1.8, NLTK 3 installed 
- PurePOS compiled and the path is set in IOB_tagger_purepos.sh

## Usage

- Run ./start.sh and wait...
- See .sh and and .py files for documentation...
- PurePOS as an IOB tagger can be invoked separately from IOB_tagger_purepos.sh (You must set PATHTOPUREPOS variable first!). 

## Warning

- Converters may contain bugs. Please check intermediate data files!
- HunTag3 has very slow learning-time on lexicalised input
- The whole process takes much time!

## License

The repository contains many 3rd-party code, that has its own license.
This code is made available under the GNU Lesser General Public License v3.0.


## Reference

If you use this program please cite:

```
	@inproceedings{gut-besser-chunker,
	  author    = {{I}ndig, {B}al\'azs and {I}stv\'an, {E}ndr\'edy},
	  title     = {{Gut, Besser, Chunker} -- {S}electing the best models for text chunking with voting},
	  booktitle = {Computational Linguistics and Intelligent Text Processing - 17th International Conference, CICLing 2016, Konya, Turkey, April 3-9, 2016},
	  year      = {2016},
	  publisher  = {Springer} 
	}
```
