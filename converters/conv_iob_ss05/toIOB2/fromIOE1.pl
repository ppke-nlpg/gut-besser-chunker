#!/usr/bin/perl

#Convert merged test file from IOE1 to IOB2
#Input: IOE1
#Output: IOB2

use strict;

#open (inFP_iob2, "<test.iob2.wch100.merge");
my $line_iob2;
#my @ref;

my $line;
my @iob2;
my @ioe1;
my $i=0;

# === read a line from file ===
while($line=<>){
    
    #$line_iob2=<inFP_iob2>;	
    #chomp($line_iob2);
    #$ref[$i] = $line_iob2;
    
    chomp($line);
    $iob2[$i] = $line;
    $ioe1[$i] = $line;
    #print $iob2[$i],"\n";
    $i++; 
}

# 
for (my $j=0;$j<=$#iob2;$j++){
    # === split a line into words ===	
    my @iob2_words = split(' ',$iob2[$j]);
    
    # === skip blank line ===
    if ($#iob2_words < 1){
    	#print "\n";
    	next;
    }        
    
    # === split a tagged chunk, eg.I-NP => "I" and "NP" ===
    my @cur = split ('-',$iob2_words[3]);
    
    # === previous ===
    my @ioe1_words = split(' ',$ioe1[$j-1]);
    my @prv = split('-',$ioe1_words[3]);
        
    # === case "I" ===
    if ($cur[0] eq "I"){
        	
        # "B" if previous(I) is "O","E" or empty ===
        if ($prv[0] eq "O" or $prv[0] eq "E" or $prv[0] =~ /^$/){
        	$iob2[$j] = $iob2_words[0]." ".$iob2_words[1]." ".$iob2_words[2]." B-".$cur[1]; 
        	
        # "B" if previous(I) is "I" and previous != cur 
        }elsif ($prv[0] eq "I" and $prv[1] ne $cur[1]){
        	$iob2[$j] = $iob2_words[0]." ".$iob2_words[1]." ".$iob2_words[2]." B-".$cur[1]; 
        }
    }
    
    # === "E" => "I" ===
    if ($cur[0] eq "E"){
    	$iob2[$j] = $iob2_words[0]." ".$iob2_words[1]." ".$iob2_words[2]." I-".$cur[1]; 
    }
}

for(my $j=0;$j<=$#iob2;$j++){
    my @words = split(' ',$iob2[$j]);
    #my @words_ref = split(' ',$ref[$j]);
    #print $words[0]," ";
    #print $words[1]," ";
    #print $words_ref[2]," ";
    print $words[1]," ",$words[2]," ",$words[3],"\n";	
}
